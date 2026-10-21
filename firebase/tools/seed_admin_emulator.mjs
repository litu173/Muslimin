// Test data for trying the admin website against the LOCAL emulators only:
//   firebase emulators:start --only firestore,auth --project demo-muslimin
//   FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 \
//     node seed_admin_emulator.mjs
// then open docs/admin/?emu and sign in as admin@test.local / admin123.
// Refuses to run against anything but the emulators.
import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore, GeoPoint, Timestamp } from 'firebase-admin/firestore';

if (!process.env.FIRESTORE_EMULATOR_HOST || !process.env.FIREBASE_AUTH_EMULATOR_HOST) {
  console.error('Emulators only – set FIRESTORE_EMULATOR_HOST and FIREBASE_AUTH_EMULATOR_HOST.');
  process.exit(1);
}
initializeApp({ projectId: 'demo-muslimin' });
const db = getFirestore();
const auth = getAuth();

const B32 = '0123456789bcdefghjkmnpqrstuvwxyz';
function geohash(lat, lng, p = 9) {
  let la = [-90, 90], lo = [-180, 180], h = '', bit = 0, ch = 0, even = true;
  while (h.length < p) {
    const r = even ? lo : la, v = even ? lng : lat, mid = (r[0] + r[1]) / 2;
    if (v >= mid) { ch = (ch << 1) | 1; r[0] = mid; } else { ch <<= 1; r[1] = mid; }
    even = !even;
    if (++bit === 5) { h += B32[ch]; bit = 0; ch = 0; }
  }
  return h;
}
const geo = (lat, lng) => ({ geopoint: new GeoPoint(lat, lng), geohash: geohash(lat, lng) });
const ago = (days) => Timestamp.fromMillis(Date.now() - days * 864e5);

const admin = await auth.createUser({ uid: 'admin1', email: 'admin@test.local', password: 'admin123', displayName: 'Test Admin' })
  .catch(() => auth.getUser('admin1'));
await db.doc('users/admin1').set({ name: 'Test Admin', email: 'admin@test.local', phone: '', role: 'superAdmin', createdAt: ago(40) });

const names = ['Rahim Uddin', 'Karim Ahmed', 'Fatema Begum', 'Abdullah Khan', 'Nusrat Jahan', 'Tanvir Hasan', 'Sadia Islam',
  'Mahmudul Hasan', 'Ayesha Siddiqua', 'Imran Hossain', 'Rafiq Mia', 'Shirin Akter', 'Habib Rahman', 'Jamal Uddin'];
for (const [i, n] of names.entries()) {
  const uid = `u${i + 1}`;
  await auth.createUser({ uid, email: `${n.split(' ')[0].toLowerCase()}@test.local`, password: 'test1234', displayName: n }).catch(() => {});
  await db.doc(`users/${uid}`).set({
    name: n, email: `${n.split(' ')[0].toLowerCase()}@test.local`, phone: '',
    role: i === 13 ? 'admin' : i === 12 ? 'editor' : i === 11 ? 'volunteer' : 'user', createdAt: ago(i * 2),
    ...(i < 10 ? { lastSeenAt: ago(i * 6), appVersion: '1.20.0', platform: i % 2 ? 'android' : 'iOS' } : {}),
    follows: i % 3 ? { m1: {}, m2: {} } : {}, fcmTokens: i % 2 ? [`token-${uid}`] : [], ...(i === 5 ? { editBlocked: true } : {}),
  });
}

const masjids = [
  ['m1', 'Baitul Aman Jame Masjid', 'বায়তুল আমান জামে মসজিদ', 'Dhaka', 'Dhanmondi', 23.7465, 90.3747, 'approved', true],
  ['m2', 'Moghbazar Jame Masjid', 'মগবাজার জামে মসজিদ', 'Dhaka', 'Ramna', 23.7486, 90.4040, 'approved', true],
  ['m3', 'Taqwa Masjid', 'তাকওয়া মসজিদ', 'Dhaka', 'Dhanmondi', 23.7420, 90.3790, 'approved', false],
  ['m4', 'Masjid-e-Noor', 'মসজিদে নূর', 'Dhaka', 'Ramna', 23.7442, 90.3990, 'approved', true],
  ['m5', 'Diluroad Chhata Masjid', 'দিলুরোড ছাতা মসজিদ', 'Dhaka', 'Ramna', 23.7470, 90.4010, 'approved', true],
  ['m6', 'Chawkbazar Shahi Masjid', 'চকবাজার শাহী মসজিদ', 'Dhaka', 'Chak Bazar', 23.7180, 90.3960, 'approved', false],
  ['m7', 'Andarkilla Shahi Jame Masjid', 'আন্দরকিল্লা শাহী জামে মসজিদ', 'Chattogram', 'Kotwali', 22.3420, 91.8370, 'approved', true],
  ['m8', 'Shah Jalal Dargah Masjid', 'শাহজালাল দরগাহ মসজিদ', 'Sylhet', 'Sylhet Sadar', 24.9010, 91.8680, 'approved', false],
  ['m9', 'New Pending Masjid', 'নতুন মসজিদ', 'Dhaka', 'Mohammadpur', 23.7600, 90.3600, 'pending', false],
  ['m10', 'Uttara Sector 7 Masjid', '', 'Dhaka', 'Uttara', 23.8700, 90.3990, 'pending', false],
  ['m11', 'Old Rejected Masjid', '', 'Gazipur', 'Gazipur Sadar', 23.9990, 90.4200, 'rejected', false],
  ['m12', 'East London Mosque', '', 'London', 'Whitechapel', 51.5175, -0.0653, 'approved', true, 'GB'],
  ['m13', 'Jumeirah Mosque', '', 'Dubai', 'Jumeirah', 25.2339, 55.2650, 'approved', false, 'AE'],
];
const jamat = { fajr: '05:00', dhuhr: '13:15', asr: '16:30', maghrib: '17:45', isha: '19:30', jumuah: '13:30' };
for (const [id, name, nameBn, district, thana, lat, lng, status, times, country] of masjids) {
  await db.doc(`masjids/${id}`).set({
    name, nameLower: name.toLowerCase(), nameBn, address: `${thana}, ${district}`, district, thana,
    ...(country ? { country } : {}), status, ownerUid: status === 'pending' ? 'u2' : 'admin1',
    ownerPhone: status === 'pending' ? '+8801712345678' : '', phoneVerified: false, nid: status === 'pending' ? '1234567890' : '',
    submitterRole: 'committee', locationAccuracyM: status === 'pending' ? 12 : 0, locationSource: status === 'pending' ? 'gps' : 'map',
    agreedToTerms: true, jamat: times ? jamat : {}, hasJamat: times, maktab: times ? { days: [6, 7, 1, 2, 3, 4], morning: '06:20-07:20', evening: '17:00-18:00' } : { days: [] },
    staff: times ? { imam: { name: 'Maulana Abdul Karim', phone: '01711000000' } } : {}, liveUrl: null, isLive: false,
    rejectionReason: status === 'rejected' ? 'Location did not match' : null, source: id === 'm6' ? 'osm' : 'admin',
    geo: geo(lat, lng), createdAt: ago(status === 'pending' ? 1 : 30), ...(times ? { jamatUpdatedAt: ago(3), updatedByName: 'Rahim Uddin', updatedBy: 'u1' } : {}),
  });
}
// volunteers, history, channel, notices
await db.doc('masjids/m1/editors/u1').set({ uid: 'u1', name: 'Rahim Uddin', masjidId: 'm1', masjidName: 'Baitul Aman Jame Masjid', lat: 23.7466, lng: 90.3748, distanceM: 120, createdAt: ago(5) });
await db.doc('masjids/m2/editors/u3').set({ uid: 'u3', name: 'Fatema Begum', masjidId: 'm2', masjidName: 'Moghbazar Jame Masjid', lat: 23.7487, lng: 90.4041, distanceM: 340, createdAt: ago(2) });
await db.collection('masjids/m1/edits').add({ masjidId: 'm1', masjidName: 'Baitul Aman Jame Masjid', uid: 'u1', name: 'Rahim Uddin', field: 'jamat',
  before: { ...jamat, isha: '19:45' }, after: jamat, at: ago(3) });
await db.collection('masjids/m2/edits').add({ masjidId: 'm2', masjidName: 'Moghbazar Jame Masjid', uid: 'u3', name: 'Fatema Begum', field: 'staff',
  before: {}, after: { imam: { name: 'Maulana Abdul Karim', phone: '01711000000' } }, at: ago(1) });
for (const [i, uid] of ['u1', 'u2', 'u4'].entries()) {
  await db.doc(`masjids/m1/members/${uid}`).set({ uid, masjidId: 'm1', masjidName: 'Baitul Aman Jame Masjid', name: names[+uid.slice(1) - 1], role: i ? 'member' : 'editor', joinedAt: ago(10 - i) });
}
await db.collection('masjids/m1/messages').add({ masjidId: 'm1', masjidName: 'Baitul Aman Jame Masjid', authorUid: 'u1', authorName: 'Rahim Uddin', text: 'আজ এশার পর তালিম হবে ইনশাআল্লাহ।', createdAt: ago(0.5) });
for (const [i, t] of ['Weekly Talim after Isha', 'Janaza of Abdul Malek', 'Waz Mahfil on Friday'].entries()) {
  await db.collection('notices').add({ masjidId: `m${i + 1}`, masjidName: masjids[i][1], title: t, body: 'Everyone is invited.', category: ['talim', 'janaza', 'mahfil'][i], createdAt: ago(i) });
}
// review queue
await db.collection('suggestions').add({ name: 'Kalabagan Masjid', nameBn: 'কলাবাগান মসজিদ', lat: 23.7510, lng: 90.3830, district: 'Dhaka', thana: 'Kalabagan', uid: 'u4', userName: 'Abdullah Khan', status: 'open', createdAt: ago(0.3) });
await db.doc('reports/m3_u2').set({ masjidId: 'm3', masjidName: 'Taqwa Masjid', district: 'Dhaka', uid: 'u2', userName: 'Karim Ahmed', reason: 'wrongTime', note: 'Fajr is 4:50 now', status: 'open', createdAt: ago(0.2) });
await db.doc('reports/m5_u6').set({ masjidId: 'm5', masjidName: 'Diluroad Chhata Masjid', district: 'Dhaka', uid: 'u6', userName: 'Tanvir Hasan', reason: 'wrongLocation', note: '', status: 'open', createdAt: ago(1) });
await db.collection('announcements').add({ title: 'মুসলিমিন আপডেট এসেছে 🎉', body: 'নতুন: দৈনিক জিকির ও তাসবিহ কাউন্টার।', type: 'update', createdAt: ago(1) });
console.log('Seeded emulator: admin@test.local / admin123');
