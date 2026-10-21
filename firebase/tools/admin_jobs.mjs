// Runs the work the admin website (docs/admin) queues in `adminJobs` that
// needs the Firebase Admin SDK – the free plan has no Cloud Functions:
//   * push         – a notification to everyone, a masjid's followers, a
//                    channel's members or one user (and, for everyone,
//                    saved in `announcements` for the Notifications page)
//   * disableUser / enableUser – stop / allow signing in
//   * deleteUser   – delete the sign-in account and the profile
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
    case 'user': {
      if (!t.id) throw new Error('user id missing');
      return toTokens(await allTokens([t.id]), {
        notification: { title, body }, data: { type: 'news' }, android,
      });
    }
    default:
      throw new Error(`unknown target ${t.type}`);
  }
}

async function run(job) {
  const p = job.payload || {};
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
