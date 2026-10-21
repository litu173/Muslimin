// Shared reads and writes for the admin views – written the same way the app
// writes them, so the app's edit history, nearby search and push keep working.
import {
  db, me, emu, doc, collection, addDoc, updateDoc, writeBatch, serverTimestamp,
  GeoPoint, geohash, logAction,
} from './fb.js';

export const PRAYERS = [
  ['fajr', 'Fajr'], ['dhuhr', 'Dhuhr'], ['asr', 'Asr'], ['maghrib', 'Maghrib'],
  ['isha', 'Isha'], ['jumuah', "Jumu'ah"],
];
export const STAFF = [['khatib', 'Khatib'], ['imam', 'Imam'], ['muazzin', 'Muazzin']];
export const DAYS = [[6, 'Sat'], [7, 'Sun'], [1, 'Mon'], [2, 'Tue'], [3, 'Wed'], [4, 'Thu'], [5, 'Fri']];
export const STATUSES = ['approved', 'pending', 'rejected', 'suspended'];
export const REASONS = {
  wrongTime: 'Wrong jamat time', wrongLocation: 'Wrong location', wrongInfo: 'Wrong info',
  closed: 'Closed / not a masjid', duplicate: 'Duplicate', other: 'Other',
};

// Countries for masjids outside Bangladesh (ISO code, name).
export const COUNTRIES = [
  ['BD', 'Bangladesh'], ['IN', 'India'], ['PK', 'Pakistan'], ['SA', 'Saudi Arabia'],
  ['AE', 'United Arab Emirates'], ['QA', 'Qatar'], ['KW', 'Kuwait'], ['OM', 'Oman'],
  ['BH', 'Bahrain'], ['MY', 'Malaysia'], ['ID', 'Indonesia'], ['SG', 'Singapore'],
  ['TR', 'Türkiye'], ['GB', 'United Kingdom'], ['US', 'United States'], ['CA', 'Canada'],
  ['AU', 'Australia'], ['IT', 'Italy'], ['DE', 'Germany'], ['FR', 'France'], ['JP', 'Japan'],
  ['MV', 'Maldives'], ['NP', 'Nepal'], ['LK', 'Sri Lanka'], ['ZA', 'South Africa'],
];
export const countryName = (c) => (COUNTRIES.find(([k]) => k === (c || 'BD')) || [c, c])[1];

let thanas;
/** {district: [thana…]} for Bangladesh. */
export async function bdThanas() {
  thanas ??= await (await fetch('data/thanas.json')).json();
  return thanas;
}

/** Masjid doc -> plain object with lat/lng. */
export function masjidOf(d) {
  const m = { id: d.id, ...d.data() };
  const gp = m.geo?.geopoint;
  m.lat = gp?.latitude; m.lng = gp?.longitude;
  m.country ||= 'BD';
  return m;
}

export const geoData = (lat, lng) => ({ geopoint: new GeoPoint(lat, lng), geohash: geohash(lat, lng) });

/**
 * Changes a masjid like the app does: the update plus an `edits` entry
 * (field jamat / staff / maktab / location) so the app's history and undo
 * see it, and an admin-log line.
 */
export async function loggedUpdate(m, field, before, after, changes) {
  const ref = doc(db, 'masjids', m.id);
  const b = writeBatch(db);
  b.update(ref, {
    ...changes, updatedBy: me.uid, updatedByName: me.name || 'Admin', updatedAt: serverTimestamp(),
  });
  if (['jamat', 'staff', 'maktab', 'location'].includes(field)) {
    b.set(doc(collection(ref, 'edits')), {
      masjidId: m.id, masjidName: m.name, uid: me.uid, name: me.name || 'Admin',
      field, before, after, at: serverTimestamp(),
    });
  }
  await b.commit();
  await logAction(`masjid.${field}`, `masjids/${m.id}`, { name: m.name });
}

export const locationChange = (lat, lng, district, thana, country) => ({
  geo: geoData(lat, lng), locationSource: 'map', locationAccuracyM: 0,
  district, thana, country: country || 'BD',
});

export async function setStatus(m, status, reason = null) {
  await updateDoc(doc(db, 'masjids', m.id), {
    status, rejectionReason: reason, reviewedBy: me.uid, reviewedAt: serverTimestamp(),
  });
  await logAction(`masjid.${status}`, `masjids/${m.id}`, { name: m.name, reason });
}

// ---------------------------------------------------------------- jobs
const TOKEN_KEY = 'muslimin-admin-gh-token';
export const ghToken = {
  get: () => { try { return localStorage.getItem(TOKEN_KEY) || ''; } catch { return ''; } },
  set: (v) => { try { v ? localStorage.setItem(TOKEN_KEY, v) : localStorage.removeItem(TOKEN_KEY); } catch { /* private mode */ } },
};

/**
 * Queues Admin-SDK work (push, disable / delete account) and starts the
 * GitHub job right away when a token is saved (Settings). Returns the job id.
 */
export async function queueJob(type, payload) {
  const ref = await addDoc(collection(db, 'adminJobs'), {
    type, payload, status: 'queued', createdBy: me.uid, createdByName: me.name, createdAt: serverTimestamp(),
  });
  await logAction(`job.${type}`, `adminJobs/${ref.id}`, payload);
  const started = await startJobs();
  return { id: ref.id, started };
}

export async function startJobs() {
  const token = ghToken.get();
  if (!token || emu) return false;
  try {
    const r = await fetch('https://api.github.com/repos/litu173/Muslimin/actions/workflows/admin-jobs.yml/dispatches', {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}`, Accept: 'application/vnd.github+json' },
      body: JSON.stringify({ ref: 'main' }),
    });
    return r.status === 204;
  } catch { return false; }
}
