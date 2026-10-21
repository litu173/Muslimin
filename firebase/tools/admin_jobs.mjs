// Runs the work the admin website (docs/admin) queues in `adminJobs` that
// needs the Firebase Admin SDK – the free plan has no Cloud Functions:
//   * push         – a notification to everyone, a masjid's followers, a
//                    channel's members, one user or a list of users; saved
//                    for the app's Notifications page (`announcements` for
//                    everyone, users/{uid}/inbox for people)
//   * disableUser / enableUser – stop / allow signing in
//   * deleteUser   – delete the sign-in account and the profile
//   * numberMasjids – give every approved masjid without one a number, in
//                    the order they were added (counters/masjid)
// Each job is marked done or failed with a result the website shows.
//
// Run by .github/workflows/admin-jobs.yml (the website starts it right
// away; a schedule picks up anything left). Cost: 1 read when idle.
// Credentials: FIREBASE_SERVICE_ACCOUNT, or FIRESTORE_EMULATOR_HOST +
// FIREBASE_AUTH_EMULATOR_HOST for local tests (pushes are then only logged).
import { initializeApp, cert, applicationDefault } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';

const projectId = process.env.PROJECT || 'muslimin-app-bd';
const sa = process.env.FIREBASE_SERVICE_ACCOUNT;
const emulator = !!process.env.FIRESTORE_EMULATOR_HOST;
initializeApp(
  sa ? { credential: cert(JSON.parse(sa)), projectId }
    : emulator ? { projectId }
      : { credential: applicationDefault(), projectId },
);
const db = getFirestore();
const auth = getAuth();
const fcm = getMessaging();
const android = { notification: { channelId: 'notices' } };

const queued = await db.collection('adminJobs')
  .where('status', '==', 'queued')
  .orderBy('createdAt')
  .limit(20)
  .get();
if (queued.empty) {
  console.log('No admin jobs.');
  process.exit(0);
}

// Every saved push token, once, with its profile (to drop dead ones).
async function allTokens(uids) {
  const owners = new Map();
  const docs = uids
    ? (await db.getAll(...uids.map((u) => db.doc(`users/${u}`)), { fieldMask: ['fcmTokens'] }))
    : (await db.collection('users').select('fcmTokens').get()).docs;
  for (const u of docs) {
    if (!u.exists) continue;
    for (const t of u.get('fcmTokens') || []) owners.set(t, u.ref);
  }
  return owners;
}

async function toTokens(owners, message) {
  const tokens = [...owners.keys()];
  if (emulator) return `would send to ${tokens.length} phones`;
  let ok = 0;
  const dead = [];
  for (let i = 0; i < tokens.length; i += 500) {
    const batch = tokens.slice(i, i + 500);
    const res = await fcm.sendEachForMulticast({ ...message, tokens: batch });
    ok += res.successCount;
    res.responses.forEach((r, k) => {
      const code = r.error?.code || '';
      if (code.includes('not-registered') || code.includes('invalid-registration-token')) {
        dead.push(batch[k]);
      }
    });
  }
  for (const t of dead) {
    await owners.get(t).update({ fcmTokens: FieldValue.arrayRemove(t) });
  }
  return `sent to ${ok} of ${tokens.length} phones` + (dead.length ? `, ${dead.length} stale removed` : '');
}

async function push(p) {
  const title = `${p.title || ''}`.trim().slice(0, 120);
  const body = `${p.body || ''}`.trim().slice(0, 500);
  if (!title || !body) throw new Error('title and body are required');
  const t = p.target || { type: 'all' };
  switch (t.type) {
    case 'all': {
      const type = p.kind === 'update' ? 'update' : 'news';
      const result = await toTokens(await allTokens(), {
        notification: { title, body }, data: { type }, android,
      });
      if (p.save !== false) {
        await db.collection('announcements').add({ title, body, type, createdAt: Timestamp.now() });
      }
      return result;
    }
    case 'masjid':
    case 'channel': {
      if (!t.id) throw new Error('masjid id missing');
      const topic = `${t.type === 'masjid' ? 'masjid' : 'channel'}_${t.id}`;
      if (emulator) return `would send to topic ${topic}`;
      await fcm.send({
        topic,
        notification: { title, body },
        data: { type: t.type === 'masjid' ? 'notice' : 'channel', masjidId: t.id },
        android,
      });
      return `sent to topic ${topic}`;
    }
    case 'user':
    case 'users': {
      const uids = [...new Set(t.type === 'user' ? [t.id] : t.ids || [])].filter(Boolean).slice(0, 2000);
      if (!uids.length) throw new Error('no users');
      // Kept in each person's inbox, so it is on their Notifications page.
      const link = p.link && p.link.type ? { type: `${p.link.type}`, id: `${p.link.id || ''}` } : null;
      for (let i = 0; i < uids.length; i += 400) {
        const b = db.batch();
        for (const uid of uids.slice(i, i + 400)) {
          b.set(db.collection(`users/${uid}/inbox`).doc(), { title, body, link, createdAt: Timestamp.now() });
        }
        await b.commit();
      }
      const sent = await toTokens(await allTokens(uids), {
        notification: { title, body }, data: { type: 'inbox' }, android,
      });
      return `${uids.length} inbox${uids.length > 1 ? 'es' : ''}; ${sent}`;
    }
    default:
      throw new Error(`unknown target ${t.type}`);
  }
}

const roles = new Map();
async function roleOf(uid) {
  if (!roles.has(uid)) roles.set(uid, (await db.doc(`users/${uid}`).get()).get('role') || 'user');
  return roles.get(uid);
}

async function run(job) {
  const p = job.payload || {};
  // Accounts are disabled or deleted only on a super admin's order.
  if (['disableUser', 'enableUser', 'deleteUser', 'numberMasjids'].includes(job.type)
      && await roleOf(job.createdBy) !== 'superAdmin') {
    throw new Error('only a super admin can do this');
  }
  switch (job.type) {
    case 'push':
      return push(p);
    case 'disableUser':
    case 'enableUser': {
      const disabled = job.type === 'disableUser';
      await auth.updateUser(p.uid, { disabled });
      // Signed-in phones are refused at their next token refresh (≤1 h).
      if (disabled) await auth.revokeRefreshTokens(p.uid);
      await db.doc(`users/${p.uid}`).set({ disabled }, { merge: true });
      return disabled ? 'sign-in disabled' : 'sign-in enabled';
    }
    case 'deleteUser': {
      try { await auth.deleteUser(p.uid); } catch (e) {
        if (!`${e.code}`.includes('user-not-found')) throw e;
      }
      await db.doc(`users/${p.uid}`).delete();
      return 'account and profile deleted';
    }
    case 'numberMasjids': {
      // One read per masjid and one write per new number – run it once.
      const snap = await db.collection('masjids').where('status', '==', 'approved')
        .select('createdAt', 'number').get();
      const all = snap.docs.map((d) => ({ ref: d.ref, id: d.id, at: d.get('createdAt')?.toMillis?.() ?? 0, n: d.get('number') }));
      const max = all.reduce((a, m) => (typeof m.n === 'number' && m.n > a ? m.n : a), 0);
      const counter = db.doc('counters/masjid');
      let next = Math.max((await counter.get()).get('next') || 1, max + 1);
      const todo = all.filter((m) => typeof m.n !== 'number').sort((a, b) => a.at - b.at || a.id.localeCompare(b.id));
      for (let i = 0; i < todo.length; i += 400) {
        const b = db.batch();
        for (const m of todo.slice(i, i + 400)) b.update(m.ref, { number: next++ });
        await b.commit();
      }
      await counter.set({ next }, { merge: true });
      return `numbered ${todo.length} masjids; next number ${next}`;
    }
    default:
      throw new Error(`unknown job ${job.type}`);
  }
}

for (const d of queued.docs) {
  const job = d.data();
  try {
    const result = await run(job);
    await d.ref.update({ status: 'done', result, doneAt: Timestamp.now() });
    console.log('done', d.id, job.type, result);
  } catch (e) {
    await d.ref.update({ status: 'failed', result: `${e.message || e}`, doneAt: Timestamp.now() });
    console.error('failed', d.id, job.type, e.message || e);
  }
}
