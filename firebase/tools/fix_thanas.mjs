// Moves imported masjids into the right thana after the boundaries were
// made precise (thana_fix.json: [{osm, district, thana}], from
// build_upazilas.py + a re-check of masjids_bd.json). Writes only those
// masjids – no reads. Run by the "Fix masjid thanas" GitHub workflow (or
// locally with GOOGLE_APPLICATION_CREDENTIALS). --dry-run to just count.
import { readFileSync } from 'node:fs';
import { initializeApp, cert, applicationDefault } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const projectId = 'muslimin-app-bd';
const sa = process.env.FIREBASE_SERVICE_ACCOUNT;
initializeApp(sa ? { credential: cert(JSON.parse(sa)), projectId } : { credential: applicationDefault(), projectId });
const db = getFirestore();
const dry = process.argv.includes('--dry-run');
const rows = JSON.parse(readFileSync(new URL('./thana_fix.json', import.meta.url), 'utf8'));
let ok = 0, missing = 0;
for (const r of rows) {
  const ref = db.doc(`masjids/osm_${r.osm.replace('/', '_')}`);
  if (dry) { ok++; continue; }
  try {
    await ref.update({ district: r.district, thana: r.thana });
    ok++;
  } catch (e) {
    if (e.code === 5) missing++; // not imported (next to a registered masjid)
    else throw e;
  }
}
console.log(`${dry ? '[dry run] ' : ''}${ok} masjids moved to the right thana, ${missing} not found.`);
