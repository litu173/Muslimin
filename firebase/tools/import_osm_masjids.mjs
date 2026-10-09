// Imports the masjids prepared by prepare_osm_masjids.py into Firestore as
// approved masjid profiles owned by the super admin.
//
//   node import_osm_masjids.mjs masjids_bd.json [--dry-run] [--max 18000]
//                                               [--admin-uid UID]
//
// Credentials: a service-account key, outside the repo –
//   GOOGLE_APPLICATION_CREDENTIALS=~/keys/muslimin-admin.json
// or the local emulator: FIRESTORE_EMULATOR_HOST=127.0.0.1:8080.
//
// Safe to run again: masjids already imported (doc id osm_<type>_<id>) are
// skipped, and so is any OpenStreetMap masjid within 40 m of a masjid
// registered in the app. The free plan allows 20,000 writes a day; --max
// keeps one run under that, and the next run carries on.
import { readFileSync } from 'node:fs';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getFirestore, FieldValue, GeoPoint } from 'firebase-admin/firestore';

const args = process.argv.slice(2);
const file = args.find((a) => !a.startsWith('--') && a.endsWith('.json'));
const flag = (name) => args.includes(`--${name}`);
const opt = (name, def) => {
  const i = args.indexOf(`--${name}`);
  return i >= 0 ? args[i + 1] : def;
};
if (!file) {
  console.error('usage: node import_osm_masjids.mjs masjids_bd.json [--dry-run] [--max N] [--admin-uid UID]');
  process.exit(1);
}
const dryRun = flag('dry-run');
const max = Number(opt('max', 18000));
const projectId = opt('project', 'muslimin-app-bd');

initializeApp(
  process.env.FIRESTORE_EMULATOR_HOST
    ? { projectId }
    : { projectId, credential: applicationDefault() },
);
const db = getFirestore();

// --- geohash (9 characters, as geoflutterfire_plus stores it) -----------
const BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';
function geohash(lat, lng, len = 9) {
  let [latLo, latHi, lngLo, lngHi] = [-90, 90, -180, 180];
  let hash = '', bit = 0, ch = 0, even = true;
  while (hash.length < len) {
    if (even) {
      const mid = (lngLo + lngHi) / 2;
      if (lng >= mid) { ch = ch * 2 + 1; lngLo = mid; } else { ch *= 2; lngHi = mid; }
    } else {
      const mid = (latLo + latHi) / 2;
      if (lat >= mid) { ch = ch * 2 + 1; latLo = mid; } else { ch *= 2; latHi = mid; }
    }
    even = !even;
    if (++bit === 5) { hash += BASE32[ch]; bit = 0; ch = 0; }
  }
  return hash;
}

function meters(a, b) {
  const dy = (a.lat - b.lat) * 111320;
  const dx = (a.lng - b.lng) * 111320 * Math.cos((a.lat * Math.PI) / 180);
  return Math.hypot(dx, dy);
}

// --- the super admin who owns the imported profiles ---------------------
let adminUid = opt('admin-uid');
if (!adminUid) {
  const admins = await db.collection('users').where('role', '==', 'superAdmin').get();
  if (admins.size !== 1) {
    console.error(`Found ${admins.size} super admins – pass --admin-uid UID.`);
    process.exit(1);
  }
  adminUid = admins.docs[0].id;
}
console.log(`Owner (super admin): ${adminUid}`);

// --- already done? ---------------------------------------------------------
// Checked cheaply first: the full scan below reads every masjid (10,000+
// reads – a fifth of the free plan's daily 50,000).
const rows = JSON.parse(readFileSync(file, 'utf8'));
const marker = db.doc('meta/osmImport');
const done = (await marker.get()).data();
const imported = (await db.collection('masjids').where('source', '==', 'osm').count().get())
  .data().count;
if ((done && done.file === rows.length) || imported >= rows.length - 50) {
  console.log(`Already imported: ${imported} OpenStreetMap masjids are in the database. Nothing to do.`);
  if (!done && !dryRun) await marker.set({ file: rows.length, imported, at: FieldValue.serverTimestamp() });
  process.exit(0);
}
if (!flag('yes') && !dryRun && imported > 0) {
  console.error(`${imported} masjids are imported already. Re-run with --yes to finish the rest ` +
    `(it reads every masjid once).`);
  process.exit(1);
}

// --- what is there already ----------------------------------------------
const existing = await db.collection('masjids').select('geo', 'source', 'jamat', 'hasJamat').get();
const have = new Set(existing.docs.map((d) => d.id));
const registered = [];
const backfill = [];
for (const d of existing.docs) {
  const m = d.data();
  const gp = m.geo?.geopoint;
  if (m.source !== 'osm' && gp) registered.push({ lat: gp.latitude, lng: gp.longitude });
  // Older profiles lack `hasJamat` (used by the admin report).
  if (m.hasJamat === undefined) {
    backfill.push({ ref: d.ref, has: Object.keys(m.jamat ?? {}).length > 0 });
  }
}
console.log(`${existing.size} masjids in the database (${registered.length} registered in the app)`);

// --- import ---------------------------------------------------------------
let written = 0, skipped = 0, nearRegistered = 0;
let batch = db.batch(), inBatch = 0;
async function flush() {
  if (inBatch && !dryRun) await batch.commit();
  batch = db.batch();
  inBatch = 0;
}

for (const { ref, has } of backfill) {
  if (written >= max) break;
  batch.update(ref, { hasJamat: has });
  written++;
  if (++inBatch === 400) await flush();
}

for (const r of rows) {
  if (written >= max) break;
  const id = 'osm_' + r.osm.replace('/', '_');
  if (have.has(id)) { skipped++; continue; }
  if (registered.some((p) => Math.abs(p.lat - r.lat) < 0.001 && meters(p, r) < 40)) {
    nearRegistered++;
    continue;
  }
  batch.set(db.collection('masjids').doc(id), {
    name: r.name,
    nameLower: r.name.toLowerCase(),
    nameBn: r.nameBn,
    address: r.address,
    district: r.district,
    thana: r.thana,
    status: 'approved',
    ownerUid: adminUid,
    ownerPhone: '',
    phoneVerified: true,
    nid: '',
    submitterRole: 'committee',
    locationAccuracyM: 0,
    locationSource: 'map',
    agreedToTerms: true,
    jamat: {},
    hasJamat: false,
    maktab: {},
    staff: {},
    liveUrl: null,
    isLive: false,
    rejectionReason: null,
    geo: { geopoint: new GeoPoint(r.lat, r.lng), geohash: geohash(r.lat, r.lng) },
    source: 'osm',
    osmId: r.osm,
    createdAt: FieldValue.serverTimestamp(),
    reviewedBy: adminUid,
    reviewedAt: FieldValue.serverTimestamp(),
  });
  written++;
  if (++inBatch === 400) {
    await flush();
    process.stdout.write(`\r${written} written…`);
  }
}
await flush();
if (!dryRun && written < max) {
  await marker.set({ file: rows.length, imported: rows.length, at: FieldValue.serverTimestamp() });
}

const left = rows.length - skipped - nearRegistered - (written - Math.min(backfill.length, max));
console.log(`\n${dryRun ? '[dry run] would write' : 'Wrote'} ${written} documents ` +
  `(${Math.min(backfill.length, max)} backfills). Already imported: ${skipped}. ` +
  `Next to a registered masjid: ${nearRegistered}. Still to import: ${Math.max(0, left)}.`);
