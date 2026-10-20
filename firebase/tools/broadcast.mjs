// Sends one notification to every phone that registered for push (the
// fcmTokens saved on each user profile) – app-update news. Tapping it opens
// the app on About the App (data type "update"), where the latest APK is
// downloaded; app versions before 1.18.3 just open the app.
//
// Each sent message is also saved in `announcements`, so it shows on the
// app's Notifications page.
//
// Run by hand from GitHub Actions (.github/workflows/broadcast.yml):
//   TITLE="…" BODY="…" node broadcast.mjs [--send | --record]
// Without a flag it is a dry run: it only counts the phones. --record only
// saves the announcement (for one already pushed).
// Cost: one read per user profile.
import { initializeApp, cert, applicationDefault } from 'firebase-admin/app';
import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';

const projectId = 'muslimin-app-bd';
const sa = process.env.FIREBASE_SERVICE_ACCOUNT;
initializeApp(
  sa ? { credential: cert(JSON.parse(sa)), projectId }
    : { credential: applicationDefault(), projectId },
);
const db = getFirestore();
const fcm = getMessaging();

const title = (process.env.TITLE || '').trim();
const body = (process.env.BODY || '').trim();
const send = process.argv.includes('--send');
const recordOnly = process.argv.includes('--record');
if (!title || !body) {
  console.error('TITLE and BODY are required.');
  process.exit(1);
}

// On the Notifications page too.
const record = () => db.collection('announcements').add({
  title, body, type: 'update', createdAt: Timestamp.now(),
});
if (recordOnly) {
  await record();
  console.log(`Saved to announcements (not pushed): ${title}`);
  process.exit(0);
}

// Every saved token, once, remembering whose it is (to drop dead ones).
const owners = new Map();
const users = await db.collection('users').select('fcmTokens').get();
for (const u of users.docs) {
  for (const t of u.get('fcmTokens') || []) owners.set(t, u.ref);
}
const tokens = [...owners.keys()];
console.log(`${users.size} profiles, ${tokens.length} phones.`);
console.log(`Title: ${title}\nBody:  ${body}`);
if (!send) {
  console.log('Dry run – nothing sent. Run with --send to send.');
  process.exit(0);
}

let ok = 0;
const dead = [];
for (let i = 0; i < tokens.length; i += 500) {
  const batch = tokens.slice(i, i + 500);
  const res = await fcm.sendEachForMulticast({
    tokens: batch,
    notification: { title, body },
    data: { type: 'update' },
    android: { notification: { channelId: 'notices' } },
  });
  ok += res.successCount;
  res.responses.forEach((r, k) => {
    const code = r.error?.code || '';
    if (code.includes('registration-token-not-registered') ||
        code.includes('invalid-registration-token')) dead.push(batch[k]);
  });
}
// Phones that uninstalled the app: forget their tokens.
for (const t of dead) {
  await owners.get(t).update({ fcmTokens: FieldValue.arrayRemove(t) });
}
await record();
console.log(`Sent to ${ok} of ${tokens.length} phones; removed ${dead.length} stale tokens.`);
