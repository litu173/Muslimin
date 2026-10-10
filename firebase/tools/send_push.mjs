// Push notifications without Cloud Functions (which need the paid Blaze
// plan): run every few minutes by GitHub Actions (.github/workflows/push.yml),
// this finds what is new since the last run and sends it with FCM –
//   * new notice          -> topic masjid_<id>   (followers)
//   * new channel message -> topic channel_<id>  (members)
//   * jamat time changed  -> topic masjid_<id>
//   * masjid approved / rejected -> the owner's phones
// The same messages the Cloud Functions in ../functions would send.
//
// Credentials: FIREBASE_SERVICE_ACCOUNT (the key's JSON, a GitHub secret),
// or GOOGLE_APPLICATION_CREDENTIALS, or FIRESTORE_EMULATOR_HOST for tests.
// Cost: about 5 reads per run plus one per new item.
import { initializeApp, cert, applicationDefault } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';

const projectId = 'muslimin-app-bd';
const sa = process.env.FIREBASE_SERVICE_ACCOUNT;
initializeApp(
  sa ? { credential: cert(JSON.parse(sa)), projectId }
    : process.env.FIRESTORE_EMULATOR_HOST ? { projectId: process.env.PROJECT || 'demo-muslimin' }
      : { credential: applicationDefault(), projectId },
);
const db = getFirestore();
const fcm = getMessaging();
const dryRun = process.argv.includes('--dry-run') || !!process.env.FIRESTORE_EMULATOR_HOST;

const meta = db.doc('meta/push');
const now = Timestamp.now();
const last = (await meta.get()).get('lastRun');
if (!last) {
  // First run: start from now, don't send the past.
  await meta.set({ lastRun: now });
  console.log('First run – starting from now.');
  process.exit(0);
}
// Items written just before the last run may carry a slightly earlier
// server time: look back a minute more, and skip what was already sent.
const from = Timestamp.fromMillis(last.toMillis() - 60_000);
const sent = new Set((await meta.get()).get('sent') || []);
const out = [];
const send = async (key, msg) => {
  if (sent.has(key)) return;
  out.push(key);
  if (dryRun) { console.log('would send', key, JSON.stringify(msg.notification)); return; }
  try { await (msg.tokens ? fcm.sendEachForMulticast(msg) : fcm.send(msg)); }
  catch (e) { console.error('send failed', key, e.message); }
};
const android = { notification: { channelId: 'notices' } };
const cut = (s, n) => (s && s.length > n ? `${s.slice(0, n - 1)}…` : s || '');

// New notices.
for (const d of (await db.collection('notices').where('createdAt', '>', from).get()).docs) {
  const n = d.data();
  await send(`n:${d.id}`, {
    topic: `masjid_${n.masjidId}`,
    notification: { title: n.masjidName, body: n.title },
    data: { type: 'notice', masjidId: n.masjidId, noticeId: d.id },
    android,
  });
}

// New channel messages.
for (const d of (await db.collectionGroup('messages').where('createdAt', '>', from).get()).docs) {
  const m = d.data();
  const masjidId = d.ref.parent.parent.id;
  await send(`c:${d.id}`, {
    topic: `channel_${masjidId}`,
    notification: {
      title: `${m.masjidName} · ${m.authorName}`,
      body: cut(m.text, 180) || (m.attachment ? `📎 ${m.attachment.name}` : ''),
    },
    data: { type: 'channel', masjidId, messageId: d.id },
    android,
  });
}

// Jamat times changed (owners and volunteer editors).
for (const d of (await db.collection('masjids').where('jamatUpdatedAt', '>', from).get()).docs) {
  const m = d.data();
  if (m.status !== 'approved') continue;
  await send(`j:${d.id}:${m.jamatUpdatedAt.toMillis()}`, {
    topic: `masjid_${d.id}`,
    notification: { title: m.name, body: 'Jamat time has been updated' },
    data: { type: 'jamat_updated', masjidId: d.id },
    android,
  });
}

// Masjid approved / rejected: tell the owner.
for (const d of (await db.collection('masjids').where('reviewedAt', '>', from).get()).docs) {
  const m = d.data();
  if (!['approved', 'rejected'].includes(m.status) || m.source === 'osm') continue;
  const owner = await db.doc(`users/${m.ownerUid}`).get();
  const tokens = owner.get('fcmTokens') || [];
  if (!tokens.length) continue;
  const ok = m.status === 'approved';
  await send(`s:${d.id}:${m.status}`, {
    tokens,
    notification: {
      title: ok ? 'Masjid profile approved' : 'Masjid profile not approved',
      body: ok ? `${m.name} is now visible to Muslims nearby.`
        : `${m.name}: ${m.rejectionReason || 'Please review and resubmit.'}`,
    },
    data: { type: 'masjid_status', masjidId: d.id, status: m.status },
  });
}

if (!dryRun) await meta.set({ lastRun: now, sent: out.slice(-300) });
console.log(`${out.length} notification(s)${dryRun ? ' (dry run)' : ''} since ${from.toDate().toISOString()}`);
process.exit(0);
