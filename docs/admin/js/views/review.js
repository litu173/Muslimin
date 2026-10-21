// Review: masjids waiting for approval, masjids users found missing, and
// problem reports – each handled in one click.
import {
  db, me, collection, doc, query, where, orderBy, limit, getDocs, updateDoc,
  writeBatch, serverTimestamp, logAction, getCountFromServer,
} from '../fb.js';
import {
  h, icon, card, table, statusBadge, badge, input, select, field, dialog, act, go, ago,
  fmtDate, toast, clear, tabs, spinner, link, empty,
} from '../ui.js';
import { pageHead, refreshCounts } from '../app.js';
import { masjidOf, setStatus, REASONS, bdThanas, COUNTRIES, geoData, giveNumber } from '../data.js';
import { miniMap, placeOf } from './map.js';

export async function render(el, tab = 'pending') {
  el.append(pageHead('Review', 'New masjids, suggestions and problem reports'));
  const n = async (q) => { try { return (await getCountFromServer(q)).data().count; } catch { return null; } };
  const [p, s, r] = await Promise.all([
    n(query(collection(db, 'masjids'), where('status', '==', 'pending'))),
    n(query(collection(db, 'suggestions'), where('status', '==', 'open'))),
    n(query(collection(db, 'reports'), where('status', '==', 'open'))),
  ]);
  el.append(tabs([['pending', 'Masjids to approve', p], ['suggestions', 'Missing masjids', s], ['reports', 'Problem reports', r]],
    tab, (t) => go(`#/review/${t}`)));
  const body = h('div');
  el.append(body);
  body.append(spinner());
  const done = () => { refreshCounts(); clear(el); render(el, tab); };
  await ({ pending, suggestions, reports }[tab] || pending)(body, done);
}

// ---------------------------------------------------------------- pending
async function pending(body, done) {
  const snap = await getDocs(query(collection(db, 'masjids'), where('status', '==', 'pending'), orderBy('createdAt', 'desc'), limit(100)));
  const rows = snap.docs.map(masjidOf);
  clear(body).append(card(null, table([
    { label: 'Masjid', cell: (m) => h('div.t-name', h('b', m.name), h('span', `${m.thana || ''}, ${m.district || ''}`)) },
    { label: 'Submitted by', cell: (m) => h('div.t-name', h('b', m.ownerPhone || '–'), h('span', m.phoneVerified ? 'phone verified' : 'phone not verified')) },
    { label: 'Location', cell: (m) => `${m.locationSource || 'gps'}${m.locationAccuracyM ? ` ±${Math.round(m.locationAccuracyM)} m` : ''}` },
    { label: 'When', class: 'nowrap', cell: (m) => ago(m.createdAt) },
    { label: '', class: 'r nowrap', cell: (m) => h('div.row.end',
      h('button.btn.btn-sm.btn-ok', { onclick: (e) => { e.stopPropagation(); act(e.currentTarget, () => setStatus(m, 'approved'), 'Approved.').then(done); } }, 'Approve'),
      h('button.btn.btn-sm', { onclick: (e) => { e.stopPropagation(); reject(m, done); } }, 'Reject')) },
  ], rows, { onRow: (m) => go(`#/masjid/${m.id}`), emptyText: 'Nothing waiting – all caught up.' })));
}

async function reject(m, done) {
  const r = input({ placeholder: 'e.g. Location is wrong, NID did not match' });
  const ok = await dialog({ title: `Reject ${m.name}?`, body: field('Reason (the owner sees this)', r),
    actions: [{ label: 'Cancel', value: false }, { label: 'Reject', value: true, kind: 'danger' }] });
  if (!ok) return;
  await act(null, () => setStatus(m, 'rejected', r.value.trim() || null), 'Rejected.');
  done();
}

// ---------------------------------------------------------------- suggestions
async function suggestions(body, done) {
  const snap = await getDocs(query(collection(db, 'suggestions'), where('status', '==', 'open'), orderBy('createdAt', 'desc'), limit(100)));
  clear(body);
  if (snap.empty) { body.append(card(null, empty('No missing masjids suggested right now.'))); return; }
  const grid = h('div.grid.g2');
  body.append(grid);
  for (const d of snap.docs) {
    const s = { id: d.id, ...d.data() };
    const mapBox = h('div.map', { style: { height: '200px' } });
    setTimeout(() => miniMap(mapBox, s.lat, s.lng), 0);
    grid.append(card(h('div.row', h('h2', s.name), h('div.grow'), badge(ago(s.createdAt), 'mute')),
      s.nameBn ? h('div.muted', s.nameBn) : null,
      h('div.small', { style: { margin: '6px 0 10px' } }, `${s.thana || '?'}, ${s.district || '?'} · suggested by `, link(`/user/${s.uid}`, s.userName || 'a user')),
      mapBox,
      h('div.row.end', { style: { marginTop: '12px' } },
        h('button.btn', { onclick: (e) => act(e.currentTarget, async () => {
          await updateDoc(d.ref, { status: 'rejected' });
          await logAction('suggestion.reject', `suggestions/${s.id}`, { name: s.name });
        }, 'Rejected.').then(done) }, 'Reject'),
        h('button.btn.btn-ok', { onclick: () => approveSuggestion(s, done) }, 'Add to the app'))));
  }
}

/** Same as the app: an approved masjid, owned by the admin, whose finder becomes its first volunteer editor. */
async function approveSuggestion(s, done) {
  const thanas = await bdThanas();
  const place = await placeOf(s.lat, s.lng);
  const cc = place?.country && COUNTRIES.some(([c]) => c === place.country) ? place.country : 'BD';
  const name = input({ value: s.name });
  const nameBn = input({ value: s.nameBn || '' });
  const country = select(COUNTRIES, cc);
  const districts = Object.keys(thanas).sort();
  const district = select(districts.map((x) => [x, x]), districts.includes(s.district) ? s.district : 'Dhaka');
  const thana = select([]);
  const fill = () => { clear(thana).append((thanas[district.value] || []).map((t) => h('option', { value: t, selected: t === s.thana }, t))); };
  fill(); district.onchange = fill;
  const region = input({ value: place?.region || s.district || '' });
  const area = input({ value: place?.area || s.thana || '' });
  const bd = h('div.grid.g2', field('District', district), field('Thana', thana));
  const intl = h('div.grid.g2', field('City / region', region), field('Area', area));
  const sync = () => { bd.hidden = country.value !== 'BD'; intl.hidden = country.value === 'BD'; };
  country.onchange = sync; sync();
  const ok = await dialog({
    title: 'Add this masjid',
    body: h('div', field('Name (English)', name), field('Name (Bangla)', nameBn), field('Country', country), bd, intl),
    actions: [{ label: 'Cancel', value: false }, { label: 'Add to the app', value: true, kind: 'ok' }],
  });
  if (!ok) return;
  const isBd = country.value === 'BD';
  await act(null, async () => {
    const ref = doc(collection(db, 'masjids'));
    const b = writeBatch(db);
    b.set(ref, {
      name: name.value.trim(), nameLower: name.value.trim().toLowerCase(), nameBn: nameBn.value.trim(), address: '',
      country: country.value, district: isBd ? district.value : region.value.trim(), thana: isBd ? thana.value : area.value.trim(),
      status: 'approved', ownerUid: me.uid, ownerPhone: '', phoneVerified: false, nid: '', submitterRole: 'committee',
      locationAccuracyM: 0, locationSource: 'map', agreedToTerms: true, jamat: {}, hasJamat: false,
      maktab: { days: [], morning: null, evening: null }, staff: {}, liveUrl: null, isLive: false, rejectionReason: null,
      geo: geoData(s.lat, s.lng), source: 'user', suggestedBy: s.uid,
      createdAt: serverTimestamp(), reviewedBy: me.uid, reviewedAt: serverTimestamp(),
    });
    b.set(doc(ref, 'editors', s.uid), {
      uid: s.uid, name: s.userName || '', masjidId: ref.id, masjidName: name.value.trim(),
      lat: s.lat, lng: s.lng, distanceM: 0, createdAt: serverTimestamp(),
    });
    b.update(doc(db, 'suggestions', s.id), { status: 'approved', masjidId: ref.id });
    await b.commit();
    await giveNumber(ref.id);
    await logAction('suggestion.approve', `masjids/${ref.id}`, { name: name.value.trim() });
  }, 'Added – the finder can now set its times.');
  done();
}

// ---------------------------------------------------------------- reports
async function reports(body, done) {
  const snap = await getDocs(query(collection(db, 'reports'), where('status', '==', 'open'), orderBy('createdAt', 'desc'), limit(100)));
  clear(body).append(card(null, table([
    { label: 'Masjid', cell: (d) => link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid') },
    { label: 'Problem', cell: (d) => h('div.t-name', h('b', REASONS[d.data().reason] || d.data().reason), h('span', d.data().note || '')) },
    { label: 'From', cell: (d) => link(`/user/${d.data().uid}`, d.data().userName || 'User') },
    { label: 'When', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
    { label: '', class: 'r', cell: (d) => h('button.btn.btn-sm.btn-ok', { onclick: (e) => act(e.currentTarget, async () => {
      await updateDoc(d.ref, { status: 'resolved', resolvedBy: me.uid, resolvedAt: serverTimestamp() });
      await logAction('report.resolve', `reports/${d.id}`, { masjid: d.data().masjidName });
    }, 'Resolved.').then(done) }, 'Resolve') },
  ], snap.docs, { emptyText: 'No open problem reports.' })));
}
