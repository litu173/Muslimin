// Masjids: search, filter by status / place / times, list or map, add new.
import {
  db, me, collection, query, where, orderBy, limit, startAfter, getDocs, getDoc, addDoc, doc,
  writeBatch, serverTimestamp, logAction,
} from '../fb.js';
import {
  h, icon, card, table, statusBadge, badge, input, select, field, dialog, act, go,
  ago, toast, clear, spinner, num,
} from '../ui.js';
import { pageHead } from '../app.js';
import {
  bdThanas, masjidOf, STATUSES, COUNTRIES, countryName, geoData, giveNumber, PRAYERS, loggedUpdate,
  toCsv, parseCsv, download, pickFile,
} from '../data.js';
import { suggestBangla } from '../ai.js';
import { pickOnMap } from './map.js';

const PAGE = 50;
const state = { q: '', status: '', country: 'BD', district: '', thana: '', times: '', view: 'list' };

export async function render(el, district, thana, country) {
  // Opened from Locations: #/masjids/<district>/<thana>[/<country>]
  if (district != null) Object.assign(state, { q: '', district: district || '', thana: thana || '', country: country || 'BD' });
  const thanas = await bdThanas();
  const districts = Object.keys(thanas).sort();
  el.append(pageHead('Masjids', 'Every masjid in the app',
    h('button.btn.btn-primary', { onclick: () => addMasjid(thanas) }, icon('plus', 18), 'Add masjid')));

  const out = h('div');
  let cursor = null, rows = [];

  const qIn = input({ placeholder: 'Search by name (English) or number…', value: state.q });
  const stSel = select([['', 'All statuses'], ...STATUSES.map((s) => [s, s[0].toUpperCase() + s.slice(1)])], state.status);
  const coSel = select(COUNTRIES, state.country);
  const diSel = select([['', 'All districts'], ...districts.map((d) => [d, d])], state.district);
  const thSel = select([['', 'All thanas']], state.thana);
  const tiSel = select([['', 'Times: any'], ['yes', 'With jamat times'], ['no', 'Without times']], state.times);
  const viewSel = select([['list', 'List'], ['map', 'Map']], state.view);
  const fillThanas = () => {
    clear(thSel).append(h('option', { value: '' }, 'All thanas'),
      (thanas[diSel.value] || []).map((t) => h('option', { value: t, selected: t === state.thana }, t)));
  };
  fillThanas();
  const bdOnly = () => { const bd = coSel.value === 'BD'; diSel.hidden = !bd; thSel.hidden = !bd; };
  bdOnly();

  let timer;
  const apply = () => {
    Object.assign(state, {
      q: qIn.value.trim().toLowerCase(), status: stSel.value, country: coSel.value,
      district: coSel.value === 'BD' ? diSel.value : '', thana: coSel.value === 'BD' ? thSel.value : '',
      times: tiSel.value, view: viewSel.value,
    });
    cursor = null; rows = [];
    load();
  };
  qIn.oninput = () => { clearTimeout(timer); timer = setTimeout(apply, 350); };
  stSel.onchange = apply; tiSel.onchange = apply; thSel.onchange = apply; viewSel.onchange = apply;
  diSel.onchange = () => { state.thana = ''; fillThanas(); apply(); };
  coSel.onchange = () => { bdOnly(); apply(); };

  const tools = h('div.row', { style: { marginBottom: '10px' } },
    h('button.btn.btn-sm', { onclick: () => exportCsv(rows) }, 'Export shown (CSV)'),
    h('button.btn.btn-sm', { onclick: () => importTimes(() => { rows = []; load(); }) }, 'Update jamat times from CSV'),
    h('button.btn.btn-sm', { onclick: () => banglaNames(rows, () => { rows = []; load(); }) }, '✨ Bangla names for shown'));
  el.append(card(null,
    h('div.filters', h('div.search', icon('search'), qIn), stSel, coSel, diSel, thSel, tiSel, viewSel),
    tools,
    h('div.muted.small', 'Name search looks at the start of the English name, across all places; type a number to find Masjid No. N. Clear it to filter by place.'),
    out));

  async function load(more = false) {
    if (!more) clear(out).append(spinner());
    const c = [];
    const base = collection(db, 'masjids');
    let q;
    if (/^#?\d+$/.test(state.q)) {
      c.push(where('number', '==', Number(state.q.replace('#', ''))));
    } else if (state.q) {
      // Prefix search (index status + nameLower).
      if (state.status) c.push(where('status', '==', state.status));
      c.push(orderBy('nameLower'), where('nameLower', '>=', state.q), where('nameLower', '<=', `${state.q}`));
    } else {
      if (state.status) c.push(where('status', '==', state.status));
      if (state.country !== 'BD') c.push(where('country', '==', state.country));
      if (state.district) c.push(where('district', '==', state.district));
      if (state.thana) c.push(where('thana', '==', state.thana));
      if (state.times) c.push(where('hasJamat', '==', state.times === 'yes'));
    }
    if (more && cursor) c.push(startAfter(cursor));
    q = query(base, ...c, limit(PAGE));
    await act(null, async () => {
      const snap = await getDocs(q);
      cursor = snap.docs[snap.docs.length - 1] || null;
      rows = rows.concat(snap.docs.map(masjidOf));
      draw(snap.docs.length === PAGE);
    });
  }

  function draw(hasMore) {
    clear(out);
    out.append(h('div.muted.small', { style: { margin: '6px 0 10px' } }, `${num(rows.length)} shown${hasMore ? ' – more below' : ''}`));
    if (state.view === 'map') {
      const box = h('div.map.tall');
      out.append(box);
      setTimeout(() => {
        const pts = rows.filter((m) => m.lat != null);
        const map = L.map(box).setView(pts[0] ? [pts[0].lat, pts[0].lng] : [23.8, 90.4], pts[0] ? 13 : 7);
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19, attribution: '© OpenStreetMap' }).addTo(map);
        const color = { approved: '#2E7D4F', pending: '#B7791F', rejected: '#B3261E', suspended: '#777' };
        pts.forEach((m) => L.circleMarker([m.lat, m.lng], { radius: 7, color: color[m.status] || '#BB8907', fillOpacity: 0.85 })
          .addTo(map).bindTooltip(m.name).on('click', () => go(`#/masjid/${m.id}`)));
        if (pts.length > 1) map.fitBounds(pts.map((m) => [m.lat, m.lng]), { padding: [30, 30] });
      }, 0);
    } else {
      out.append(table([
        { label: '#', class: 'r', cell: (m) => h('span.muted', rows.indexOf(m) + 1) },
        { label: 'Masjid', cell: (m) => h('div.t-name', h('b', m.name || '(no name)'), h('span', m.nameBn || m.address || '')) },
        { label: 'Area', cell: (m) => (m.country === 'BD' ? `${m.thana || '–'}, ${m.district || '–'}` : `${m.thana || m.district || '–'}, ${countryName(m.country)}`) },
        { label: 'Masjid No.', class: 'r', cell: (m) => (m.number ? h('span.num-tag', m.number) : h('span.muted', '–')) },
        { label: 'Jamat', cell: (m) => (m.hasJamat ? badge('times set', 'ok') : badge('no times', 'mute')) },
        { label: 'Status', cell: (m) => statusBadge(m.status) },
        { label: 'Source', cell: (m) => badge({ osm: 'OpenStreetMap', user: 'Suggested', admin: 'Added by admin' }[m.source] || 'Registered', 'gold') },
        { label: 'Updated', class: 'nowrap', cell: (m) => ago(m.updatedAt || m.jamatUpdatedAt || m.createdAt) },
      ], rows, { onRow: (m) => go(`#/masjid/${m.id}`), emptyText: 'No masjids match.' }));
    }
    if (hasMore) {
      out.append(h('div.pager', h('button.btn', { onclick: (e) => act(e.currentTarget, () => load(true)) }, 'Load more')));
    }
  }

  load();
}

/** New masjid added by the admin: approved, owned by the admin. */
async function addMasjid(thanas) {
  const districts = Object.keys(thanas).sort();
  const name = input({ placeholder: 'e.g. Baitul Aman Jame Masjid' });
  const nameBn = input({ placeholder: 'বাংলা নাম (optional)' });
  const address = input({ placeholder: 'Road, area' });
  const country = select(COUNTRIES, 'BD');
  const district = select(districts.map((d) => [d, d]), 'Dhaka');
  const thana = select((thanas.Dhaka || []).map((t) => [t, t]));
  const city = input({ placeholder: 'City / region' });
  const area = input({ placeholder: 'Area / neighbourhood' });
  district.onchange = () => { clear(thana).append((thanas[district.value] || []).map((t) => h('option', { value: t }, t))); };
  let pos = null;
  const posTxt = h('span.muted.small', 'No location yet');
  const bdBox = h('div.grid.g2', field('District', district), field('Thana', thana));
  const intlBox = h('div.grid.g2', { hidden: true }, field('City / region', city), field('Area', area));
  country.onchange = () => { const bd = country.value === 'BD'; bdBox.hidden = !bd; intlBox.hidden = bd; };

  await dialog({
    title: 'Add masjid',
    wide: true,
    body: h('div',
      h('div.msg', 'Added masjids are approved straight away and owned by you; volunteers nearby can then keep the times right.'),
      field('Name (English)', name), field('Name (Bangla)', nameBn), field('Address', address),
      field('Country', country), bdBox, intlBox,
      h('div.row', h('button.btn', { type: 'button', onclick: async () => {
        const p = await pickOnMap(pos || { lat: 23.75, lng: 90.39 }, 'Place the masjid');
        if (p) { pos = p; posTxt.textContent = `${p.lat.toFixed(6)}, ${p.lng.toFixed(6)}`; }
      } }, icon('pin', 18), 'Pick location on map'), posTxt)),
    actions: [
      { label: 'Cancel', value: null },
      {
        label: 'Add masjid', kind: 'primary', run: async () => {
          if (name.value.trim().length < 3) { toast('Name is too short.', 'bad'); return false; }
          if (!pos) { toast('Pick the location on the map.', 'bad'); return false; }
          const bd = country.value === 'BD';
          const ref = await act(null, () => addDoc(collection(db, 'masjids'), {
            name: name.value.trim(), nameLower: name.value.trim().toLowerCase(), nameBn: nameBn.value.trim(),
            address: address.value.trim(), country: country.value,
            district: bd ? district.value : city.value.trim(), thana: bd ? thana.value : area.value.trim(),
            status: 'approved', ownerUid: me.uid, ownerPhone: '', phoneVerified: false, nid: '',
            submitterRole: 'committee', locationAccuracyM: 0, locationSource: 'map', agreedToTerms: true,
            jamat: {}, hasJamat: false, maktab: { days: [], morning: null, evening: null }, staff: {},
            liveUrl: null, isLive: false, rejectionReason: null, source: 'admin',
            geo: geoData(pos.lat, pos.lng), createdAt: serverTimestamp(), reviewedBy: me.uid, reviewedAt: serverTimestamp(),
          }));
          if (!ref) return false;
          await giveNumber(ref.id);
          await logAction('masjid.create', `masjids/${ref.id}`, { name: name.value.trim() });
          toast('Masjid added.');
          go(`#/masjid/${ref.id}`);
          return true;
        },
      },
    ],
  });
}

// ---------------------------------------------------------------- CSV
const TIME_COLS = PRAYERS.map(([k]) => k);

function exportCsv(rows) {
  if (!rows.length) { toast('Nothing shown to export.', 'bad'); return; }
  download(`muslimin-masjids-${new Date().toISOString().slice(0, 10)}.csv`, toCsv(
    ['id', 'number', 'name', 'name_bn', 'country', 'district', 'thana', 'address', 'status', 'lat', 'lng', ...TIME_COLS],
    rows.map((m) => [m.id, m.number ?? '', m.name, m.nameBn || '', m.country, m.district, m.thana, m.address || '', m.status,
      m.lat ?? '', m.lng ?? '', ...TIME_COLS.map((k) => m.jamat?.[k] || '')])));
}

/** "5:30", "05:30", "5.30 pm", "17:30" -> "HH:mm" (or null). */
function hhmm(v) {
  const m = `${v}`.trim().toLowerCase().match(/^(\d{1,2})[:.](\d{2})\s*(am|pm)?$/);
  if (!m) return null;
  let hr = Number(m[1]); const min = Number(m[2]);
  if (m[3] === 'pm' && hr < 12) hr += 12;
  if (m[3] === 'am' && hr === 12) hr = 0;
  if (hr > 23 || min > 59) return null;
  return `${String(hr).padStart(2, '0')}:${String(min).padStart(2, '0')}`;
}

async function importTimes(done) {
  const text = await pickFile();
  if (!text) return;
  const list = parseCsv(text).filter((r) => r.id || r.number);
  if (!list.length) { toast('The file needs an id (or number) column and prayer columns.', 'bad'); return; }
  const bad = [];
  const plan = list.map((r, i) => {
    const jamat = {};
    for (const k of TIME_COLS) {
      if (!r[k]) continue;
      const t = hhmm(r[k]);
      if (t) jamat[k] = t; else bad.push(`row ${i + 2}: ${k} “${r[k]}”`);
    }
    return { r, jamat };
  }).filter((p) => Object.keys(p.jamat).length);
  const ok = await dialog({
    title: 'Update jamat times',
    body: h('div',
      h('p', `${num(plan.length)} masjids get new times. Only the prayers filled in the file change; the others stay.`),
      bad.length ? h('div.msg.warn', `Skipped ${bad.length} unreadable time(s): ${bad.slice(0, 6).join('; ')}${bad.length > 6 ? '…' : ''}`) : null,
      h('p.muted.small', 'Each change is saved in the masjid\'s history (with undo), as if edited by you.')),
    actions: [{ label: 'Cancel', value: false }, { label: 'Update', kind: 'primary', value: true }],
  });
  if (!ok) return;
  let n = 0;
  const missing = [];
  await act(null, async () => {
    for (const { r, jamat } of plan) {
      let snap;
      if (r.id) snap = await getDoc(doc(db, 'masjids', r.id));
      else {
        const s = await getDocs(query(collection(db, 'masjids'), where('number', '==', Number(r.number)), limit(1)));
        snap = s.docs[0];
      }
      if (!snap?.exists()) { missing.push(r.id || `No. ${r.number}`); continue; }
      const m = masjidOf(snap);
      const merged = { ...(m.jamat || {}), ...jamat };
      await loggedUpdate(m, 'jamat', m.jamat || {}, merged, {
        jamat: merged, hasJamat: true, jamatUpdatedAt: serverTimestamp(),
      });
      n++;
    }
  });
  toast(`Updated ${num(n)} masjids.${missing.length ? ` Not found: ${missing.slice(0, 5).join(', ')}` : ''}`, missing.length ? 'bad' : 'ok');
  done();
}

// ---------------------------------------------------------------- Bangla names
async function banglaNames(rows, done) {
  const todo = rows.filter((m) => !m.nameBn?.trim()).slice(0, 200);
  if (!todo.length) { toast('Every masjid shown already has a Bangla name.'); return; }
  const box = h('div', spinner());
  const inputs = new Map();
  const dlg = dialog({
    title: `Bangla names – ${num(todo.length)} masjids`,
    wide: true,
    body: h('div',
      h('p.muted.small', 'Gemini suggests how each name is written in Bangla. Check and correct them – untick any that are wrong – then save. Names are proper nouns, so a person should always review.'),
      box),
    actions: [{ label: 'Cancel', value: false }, { label: 'Save ticked', kind: 'primary', run: async () => {
      const picks = [...inputs.entries()].filter(([, v]) => v.tick.checked && v.inp.value.trim());
      if (!picks.length) return true;
      const ok = await act(null, async () => {
        for (let i = 0; i < picks.length; i += 400) {
          const b = writeBatch(db);
          for (const [id, v] of picks.slice(i, i + 400)) b.update(doc(db, 'masjids', id), { nameBn: v.inp.value.trim() });
          await b.commit();
        }
        await logAction('masjid.nameBn', 'masjids', { count: picks.length });
        return true;
      }, `Saved ${picks.length} Bangla names.`);
      if (ok) done();
      return !!ok;
    } }],
  });
  try {
    const got = await suggestBangla([...new Set(todo.map((m) => m.name))], 'masjid');
    clear(box).append(table([
      { label: '', cell: (m) => inputs.get(m.id).tick },
      { label: 'Masjid', cell: (m) => h('div.t-name', h('b', m.name), h('span', `${m.thana || ''}, ${m.district || ''}`)) },
      { label: 'Bangla', cell: (m) => inputs.get(m.id).inp },
    ], todo.map((m) => {
      inputs.set(m.id, { tick: h('input.chk', { type: 'checkbox', checked: !!got[m.name] }), inp: input({ value: got[m.name] || '' }) });
      return m;
    })));
  } catch (e) {
    clear(box).append(h('div.msg.bad', e.message || `${e}`));
  }
  await dlg;
}
