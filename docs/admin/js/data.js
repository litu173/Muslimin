// Shared reads and writes for the admin views – written the same way the app
// writes them, so the app's edit history, nearby search and push keep working.
import {
  db, me, emu, doc, collection, addDoc, updateDoc, writeBatch, serverTimestamp,
  GeoPoint, geohash, logAction, runTransaction, getDoc, setDoc,
} from './fb.js';

export const PRAYERS = [
  ['fajr', 'Fajr'], ['dhuhr', 'Dhuhr'], ['asr', 'Asr'], ['maghrib', 'Maghrib'],
  ['isha', 'Isha'], ['jumuah', "Jumu'ah"],
];
export const STAFF = [['khatib', 'Khatib'], ['imam', 'Imam'], ['muazzin', 'Muazzin']];
export const DAYS = [[6, 'Sat'], [7, 'Sun'], [1, 'Mon'], [2, 'Tue'], [3, 'Wed'], [4, 'Thu'], [5, 'Fri']];
export const ROLES = [
  ['user', 'User'], ['volunteer', 'Volunteer'], ['editor', 'Editor'], ['admin', 'Admin'], ['superAdmin', 'Super admin'],
];
export const roleName = (r) => (ROLES.find(([k]) => k === (r || 'user')) || ['', r])[1];
export const ROLE_HELP = {
  user: 'Uses the app; can volunteer for masjids within 2 km.',
  volunteer: 'Trusted volunteer: can become a volunteer editor of a masjid anywhere (no 2 km limit).',
  editor: 'Can update jamat times, staff and maktab of every approved masjid.',
  admin: 'Uses this panel: approves masjids, edits everything, sends notifications. Cannot change roles, app settings or delete accounts.',
  superAdmin: 'Everything, including roles, app settings and deleting accounts.',
};
export const ROLE_KIND = { user: 'mute', volunteer: 'ok', editor: 'warn', admin: 'gold', superAdmin: 'gold' };

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
// Place names kept in config/places: Bangla names of districts, thanas,
// cities, areas and countries (English name -> Bangla), used by the app in
// Bangla, and countries added by admins (code -> English name).
export const places = { bn: {}, countries: {} };
export async function loadPlaces() {
  try {
    const d = (await getDoc(doc(db, 'config', 'places'))).data() || {};
    places.bn = d.bn || {};
    places.countries = d.countries || {};
    for (const [code, name] of Object.entries(places.countries)) {
      const i = COUNTRIES.findIndex(([c]) => c === code);
      if (i >= 0) COUNTRIES[i] = [code, name]; else COUNTRIES.push([code, name]);
    }
  } catch (e) { console.warn('places', e); }
  return places;
}
export async function savePlaces(changes = {}) {
  Object.assign(places, changes);
  await setDoc(doc(db, 'config', 'places'), { bn: places.bn, countries: places.countries, updatedAt: serverTimestamp() });
}

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
  if (status === 'approved') await giveNumber(m.id);
  await logAction(`masjid.${status}`, `masjids/${m.id}`, { name: m.name, reason });
}

/**
 * Gives an approved masjid the next masjid number (counters/masjid), the
 * same as the app. Does nothing until numbering is started in App settings,
 * or when the masjid already has one. Returns the number.
 */
export async function giveNumber(id) {
  try {
    return await runTransaction(db, async (tx) => {
      const counter = doc(db, 'counters', 'masjid');
      const ref = doc(db, 'masjids', id);
      const [c, m] = await Promise.all([tx.get(counter), tx.get(ref)]);
      if (!c.exists() || !m.exists()) return null;
      if (typeof m.data().number === 'number') return m.data().number;
      const n = c.data().next || 1;
      tx.update(ref, { number: n });
      tx.set(counter, { next: n + 1 }, { merge: true });
      return n;
    });
  } catch (e) { console.warn('number', e); return null; }
}

// ---------------------------------------------------------------- CSV
/** Rows (arrays or objects with `cols`) -> CSV text with a header. */
export function toCsv(cols, rows) {
  const esc = (v) => {
    const s = v == null ? '' : `${v}`;
    return /[",\n\r]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };
  return [cols.map(esc).join(','), ...rows.map((r) => r.map(esc).join(','))].join('\r\n');
}

/** CSV text -> array of objects keyed by the (trimmed, lower-case) header. */
export function parseCsv(text) {
  const rows = [];
  let row = [], cell = '', q = false;
  text = text.replace(/^\uFEFF/, '');
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (q) {
      if (ch === '"' && text[i + 1] === '"') { cell += '"'; i++; } else if (ch === '"') q = false; else cell += ch;
    } else if (ch === '"') q = true;
    else if (ch === ',') { row.push(cell); cell = ''; }
    else if (ch === '\n' || ch === '\r') {
      if (ch === '\r' && text[i + 1] === '\n') i++;
      row.push(cell); cell = '';
      if (row.some((c) => c.trim())) rows.push(row);
      row = [];
    } else cell += ch;
  }
  row.push(cell);
  if (row.some((c) => c.trim())) rows.push(row);
  if (!rows.length) return [];
  const head = rows[0].map((c) => c.trim().toLowerCase());
  return rows.slice(1).map((r) => Object.fromEntries(head.map((k, i) => [k, (r[i] ?? '').trim()])));
}

/** Saves text as a file in the browser. */
export function download(name, text, type = 'text/csv') {
  const a = document.createElement('a');
  a.href = URL.createObjectURL(new Blob(['\uFEFF', text], { type: `${type};charset=utf-8` }));
  a.download = name;
  a.click();
  setTimeout(() => URL.revokeObjectURL(a.href), 2000);
}

/** Asks for a file and returns its text (or null). */
export function pickFile(accept = '.csv,text/csv') {
  return new Promise((resolve) => {
    const i = document.createElement('input');
    i.type = 'file'; i.accept = accept;
    i.onchange = async () => resolve(i.files[0] ? await i.files[0].text() : null);
    i.click();
  });
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
