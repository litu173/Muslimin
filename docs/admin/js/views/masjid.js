// One masjid: everything about it, editable – info, location, jamat,
// maktab, staff, owner, volunteers, history (with undo), channel, notices,
// reports – plus status changes, notifications and deletion.
import {
  db, me, collection, doc, getDoc, getDocs, query, where, orderBy, limit, updateDoc,
  deleteDoc, writeBatch, serverTimestamp, logAction,
} from '../fb.js';
import {
  h, icon, card, statusBadge, badge, input, select, field, dialog, act, go, ago,
  fmtDate, toast, clear, empty, link, confirmDialog, table, num,
} from '../ui.js';
import { pageHead } from '../app.js';
import { suggestBangla } from '../ai.js';
import {
  bdThanas, masjidOf, loggedUpdate, locationChange, setStatus, PRAYERS, STAFF, DAYS,
  COUNTRIES, countryName, REASONS, queueJob,
} from '../data.js';
import { miniMap, pickOnMap, placeOf } from './map.js';

export async function render(el, id) {
  const snap = await getDoc(doc(db, 'masjids', id));
  if (!snap.exists()) {
    el.append(pageHead('Masjid not found'), card(null, empty('This masjid does not exist (it may have been deleted).')));
    return;
  }
  const m = masjidOf(snap);
  const reload = () => { clear(el); render(el, id); };

  // ---- header + status actions
  const statusActions = [];
  const btn = (label, kind, fn) => h(`button.btn${kind ? `.btn-${kind}` : ''}`, { onclick: (e) => fn(e.currentTarget) }, label);
  if (m.status !== 'approved') statusActions.push(btn(m.status === 'pending' ? 'Approve' : 'Reinstate', 'ok', (b) => changeStatus(b, 'approved')));
  if (m.status === 'pending') statusActions.push(btn('Reject', 'danger', (b) => changeStatus(b, 'rejected', true)));
  if (m.status === 'approved') statusActions.push(btn('Suspend', '', (b) => changeStatus(b, 'suspended', true)));

  async function changeStatus(b, status, askReason) {
    let reason = null;
    if (askReason) {
      const r = input({ placeholder: status === 'rejected' ? 'Why is it rejected? (the owner sees this)' : 'Reason (optional)' });
      const ok = await dialog({ title: status === 'rejected' ? 'Reject masjid' : 'Suspend masjid', body: field('Reason', r),
        actions: [{ label: 'Cancel', value: false }, { label: status === 'rejected' ? 'Reject' : 'Suspend', value: true, kind: 'danger' }] });
      if (!ok) return;
      reason = r.value.trim() || null;
    }
    if (await act(b, () => setStatus(m, status, reason), `Masjid ${status}.`) !== undefined) reload();
  }

  el.append(pageHead(m.name || '(no name)',
    h('span', statusBadge(m.status), ' ', m.nameBn || '', m.address ? ` · ${m.address}` : ''),
    h('button.btn', { onclick: () => history.back() }, icon('back', 18), 'Back'),
    ...statusActions));
  if (m.status === 'rejected' || m.status === 'suspended') {
    el.append(h('div.msg.warn', `${m.status === 'rejected' ? 'Rejected' : 'Suspended'}${m.rejectionReason ? `: ${m.rejectionReason}` : ''} – ${fmtDate(m.reviewedAt)}`));
  }

  const left = h('div'), right = h('div');
  el.append(h('div.grid.g2', left, right));

  left.append(infoCard(m, reload), locationCard(m, reload), jamatCard(m, reload), maktabCard(m, reload), staffCard(m, reload));
  right.append(ownerCard(m, reload), notifyCard(m));
  // These read sub-collections – loaded after the page is up.
  const lazy = [editorsCard, historyCard, reportsCard, noticesCard, channelCard];
  for (const make of lazy) {
    const slot = h('div');
    right.append(slot);
    make(m, reload).then((c) => slot.replaceWith(c)).catch((e) => { console.warn(e); slot.remove(); });
  }
  right.append(dangerCard(m));
}

// ------------------------------------------------------------------ info
function infoCard(m, reload) {
  const name = input({ value: m.name || '' });
  const nameBn = input({ value: m.nameBn || '' });
  const address = input({ value: m.address || '' });
  const live = input({ value: m.liveUrl || '', placeholder: 'https://youtube.com/…' });
  return card('Information',
    field('Name (English)', name),
    h('div.row', { style: { alignItems: 'flex-end', flexWrap: 'nowrap' } },
      h('div', { style: { flex: 1 } }, field('Name (Bangla)', nameBn)),
      h('button.btn', { style: { marginBottom: '12px' }, title: 'Suggest the Bangla name with Gemini – check it before saving', onclick: (e) => act(e.currentTarget, async () => {
        const got = await suggestBangla([name.value.trim()], 'masjid');
        const v = got[name.value.trim()];
        if (!v) throw new Error('No suggestion – type it yourself.');
        nameBn.value = v;
        toast('Suggested – check it, then Save.');
      }) }, '✨ Suggest')),
    field('Address', address),
    field('Live stream link', live, 'Shown on the masjid page when set.'),
    h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
      if (name.value.trim().length < 3) throw new Error('Name is too short.');
      await updateDoc(doc(db, 'masjids', m.id), {
        name: name.value.trim(), nameLower: name.value.trim().toLowerCase(), nameBn: nameBn.value.trim(),
        address: address.value.trim(), liveUrl: live.value.trim() || null, updatedAt: serverTimestamp(),
      });
      await logAction('masjid.info', `masjids/${m.id}`, { name: name.value.trim() });
    }, 'Saved.').then(reload) }, 'Save')));
}

// ------------------------------------------------------------------ location
function locationCard(m, reload) {
  const mapBox = h('div.map');
  if (m.lat != null) setTimeout(() => miniMap(mapBox, m.lat, m.lng), 0);
  const area = m.country === 'BD'
    ? `${m.thana || '–'}, ${m.district || '–'}`
    : `${m.thana || '–'}, ${m.district || '–'}, ${countryName(m.country)}`;
  return card(h('div.row', h('h2', 'Location'), h('div.grow'),
    h('button.btn.btn-sm', { onclick: () => editLocation(m, reload) }, icon('pin', 16), 'Change')),
  mapBox,
  h('dl.kv', { style: { marginTop: '12px' } },
    h('dt', 'Area'), h('dd', area),
    h('dt', 'Coordinates'), h('dd', m.lat != null ? `${m.lat.toFixed(6)}, ${m.lng.toFixed(6)}` : '–'),
    h('dt', 'Source'), h('dd', `${m.locationSource || 'gps'}${m.locationAccuracyM ? ` · ±${Math.round(m.locationAccuracyM)} m` : ''}`),
    h('dt', 'Open'), h('dd', m.lat != null ? h('a', { href: `https://www.google.com/maps?q=${m.lat},${m.lng}`, target: '_blank' }, 'Google Maps ↗') : '–')));
}

async function editLocation(m, reload) {
  const thanas = await bdThanas();
  const pos = await pickOnMap({ lat: m.lat ?? 23.75, lng: m.lng ?? 90.39 }, `Move ${m.name}`);
  if (!pos) return;
  const place = await placeOf(pos.lat, pos.lng);
  const country = select(COUNTRIES, place?.country && COUNTRIES.some(([c]) => c === place.country) ? place.country : (m.country || 'BD'));
  const districts = Object.keys(thanas).sort();
  const district = select(districts.map((d) => [d, d]), districts.includes(m.district) ? m.district : 'Dhaka');
  const thana = select([]);
  const fill = (v) => { clear(thana).append((thanas[district.value] || []).map((t) => h('option', { value: t, selected: t === v }, t))); };
  fill(m.thana);
  district.onchange = () => fill();
  const region = input({ value: m.country !== 'BD' ? m.district || place?.region || '' : place?.region || '' });
  const areaIn = input({ value: m.country !== 'BD' ? m.thana || place?.area || '' : place?.area || '' });
  const bd = h('div.grid.g2', field('District', district), field('Thana', thana));
  const intl = h('div.grid.g2', field('City / region', region), field('Area', areaIn));
  const sync = () => { bd.hidden = country.value !== 'BD'; intl.hidden = country.value === 'BD'; };
  country.onchange = sync; sync();
  const ok = await dialog({
    title: 'Place of the masjid',
    body: h('div', h('div.msg', `New pin: ${pos.lat.toFixed(6)}, ${pos.lng.toFixed(6)}${place?.country ? ` (OpenStreetMap: ${place.area || place.region}, ${place.country})` : ''}`),
      field('Country', country), bd, intl),
    actions: [{ label: 'Cancel', value: false }, { label: 'Save location', value: true, kind: 'primary' }],
  });
  if (!ok) return;
  const isBd = country.value === 'BD';
  const d = isBd ? district.value : region.value.trim();
  const t = isBd ? thana.value : areaIn.value.trim();
  await act(null, () => loggedUpdate(m, 'location',
    { lat: m.lat, lng: m.lng, district: m.district || '', thana: m.thana || '' },
    { lat: pos.lat, lng: pos.lng, district: d, thana: t },
    locationChange(pos.lat, pos.lng, d, t, country.value)), 'Location saved.');
  reload();
}

// ------------------------------------------------------------------ jamat
function jamatCard(m, reload) {
  const ins = {};
  const grid = h('div.times', PRAYERS.map(([k, label]) => {
    ins[k] = input({ type: 'time', value: m.jamat?.[k] || '' });
    return field(label, ins[k]);
  }));
  return card(h('div.row', h('h2', 'Jamat times'), h('div.grow'),
    m.jamatUpdatedAt ? h('span.muted.small', `updated ${ago(m.jamatUpdatedAt)}${m.updatedByName ? ` by ${m.updatedByName}` : ''}`) : null),
  grid,
  h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
    const jamat = {};
    for (const [k] of PRAYERS) if (ins[k].value) jamat[k] = ins[k].value;
    await loggedUpdate(m, 'jamat', m.jamat || {}, jamat, {
      jamat, hasJamat: Object.keys(jamat).length > 0, jamatUpdatedAt: serverTimestamp(),
    });
  }, 'Jamat times saved.').then(reload) }, 'Save times')));
}

// ------------------------------------------------------------------ maktab
function maktabCard(m, reload) {
  const mk = m.maktab || {};
  const days = new Set(mk.days || []);
  const dayEls = DAYS.map(([d, label]) => {
    const b = h(`button.day${days.has(d) ? '.on' : ''}`, { type: 'button', onclick: () => {
      days.has(d) ? days.delete(d) : days.add(d);
      b.classList.toggle('on');
    } }, label);
    return b;
  });
  const range = (v) => (v ? v.split('-') : ['', '']);
  const [ms, me2] = range(mk.morning), [es, ee] = range(mk.evening);
  const mS = input({ type: 'time', value: ms }), mE = input({ type: 'time', value: me2 });
  const eS = input({ type: 'time', value: es }), eE = input({ type: 'time', value: ee });
  return card('Maktab',
    h('div.f-label', 'Days'), h('div.days', { style: { margin: '6px 0 12px' } }, dayEls),
    h('div.grid.g2', field('Morning from', mS), field('Morning to', mE), field('Evening from', eS), field('Evening to', eE)),
    h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
      const r = (a, b) => (a.value && b.value ? `${a.value}-${b.value}` : null);
      const maktab = { days: [...days].sort(), morning: r(mS, mE), evening: r(eS, eE) };
      await loggedUpdate(m, 'maktab', mk, maktab, { maktab });
    }, 'Maktab saved.').then(reload) }, 'Save maktab')));
}

// ------------------------------------------------------------------ staff
function staffCard(m, reload) {
  const ins = {};
  const rows = STAFF.map(([k, label]) => {
    ins[k] = [input({ value: m.staff?.[k]?.name || '', placeholder: 'Name' }), input({ value: m.staff?.[k]?.phone || '', placeholder: 'Phone' })];
    return h('div.grid.g2', field(`${label} name`, ins[k][0]), field(`${label} phone`, ins[k][1]));
  });
  return card('Imam, Khatib, Muazzin', rows,
    h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
      const staff = {};
      for (const [k] of STAFF) {
        const [n, p] = ins[k];
        if (n.value.trim()) staff[k] = { name: n.value.trim(), phone: p.value.trim() };
      }
      await loggedUpdate(m, 'staff', m.staff || {}, staff, { staff });
    }, 'Staff saved.').then(reload) }, 'Save staff')));
}

// ------------------------------------------------------------------ owner
function ownerCard(m, reload) {
  const roles = { committee: 'Committee', khadem: 'Khadem', muazzin: 'Muazzin', imam: 'Imam', khatib: 'Khatib' };
  return card(h('div.row', h('h2', 'Owner & verification'), h('div.grow'),
    h('button.btn.btn-sm', { onclick: () => transferOwner(m, reload) }, 'Transfer')),
  h('dl.kv',
    h('dt', 'Owner'), h('dd', m.ownerUid ? link(`/user/${m.ownerUid}`, 'Open profile →') : '–'),
    h('dt', 'Role'), h('dd', roles[m.submitterRole] || m.submitterRole || '–'),
    h('dt', 'Phone'), h('dd', m.ownerPhone ? h('span', m.ownerPhone, ' ', m.phoneVerified ? badge('verified', 'ok') : badge('not verified', 'warn')) : '–'),
    h('dt', 'NID'), h('dd', m.nid || '–'),
    h('dt', 'Source'), h('dd', m.source === 'osm' ? 'OpenStreetMap import' : m.source === 'user' ? 'Suggested by a user' : m.source === 'admin' ? 'Added by admin' : 'Registered in the app'),
    h('dt', 'Created'), h('dd', fmtDate(m.createdAt)),
    h('dt', 'Reviewed'), h('dd', m.reviewedAt ? fmtDate(m.reviewedAt) : '–'),
    h('dt', 'Masjid id'), h('dd', h('code', m.id))));
}

async function transferOwner(m, reload) {
  const email = input({ type: 'email', placeholder: 'new.owner@email.com' });
  const ok = await dialog({
    title: 'Transfer ownership',
    body: h('div', h('p', 'The new owner manages this masjid in the app (times, notices, channel). They need a Muslimin account.'), field('Their account email', email)),
    actions: [{ label: 'Cancel', value: false }, { label: 'Transfer', value: true, kind: 'primary' }],
  });
  if (!ok) return;
  await act(null, async () => {
    const s = await getDocs(query(collection(db, 'users'), where('email', '==', email.value.trim().toLowerCase()), limit(1)));
    const u = s.docs[0] || (await getDocs(query(collection(db, 'users'), where('email', '==', email.value.trim()), limit(1)))).docs[0];
    if (!u) throw new Error('No account with that email.');
    await updateDoc(doc(db, 'masjids', m.id), { ownerUid: u.id, updatedAt: serverTimestamp() });
    await logAction('masjid.transfer', `masjids/${m.id}`, { to: u.id, email: email.value.trim() });
  }, 'Ownership transferred.');
  reload();
}

// ------------------------------------------------------------------ notify
function notifyCard(m) {
  const title = input({ value: m.name, maxLength: 120 });
  const body = h('textarea.inp', { placeholder: 'Message…', maxLength: 500 });
  const to = select([['masjid', 'People who follow this masjid'], ['channel', "This masjid's channel members"]]);
  return card('Send a notification',
    field('To', to), field('Title', title), field('Message', body),
    h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
      if (!body.value.trim()) throw new Error('Write a message.');
      const ok = await confirmDialog('Send notification?', `“${title.value}” – ${body.value.trim()}`, { ok: 'Send' });
      if (!ok) return;
      const { started } = await queueJob('push', { target: { type: to.value, id: m.id }, title: title.value.trim(), body: body.value.trim() });
      toast(started ? 'Sending now.' : 'Queued – it goes out with the next job run (add a GitHub token in Settings to send instantly).');
      body.value = '';
    }) }, icon('send', 16), 'Send')));
}

// ------------------------------------------------------------------ editors
async function editorsCard(m) {
  const snap = await getDocs(collection(db, 'masjids', m.id, 'editors'));
  const c = card(`Volunteer editors (${snap.size})`);
  c.append(snap.empty ? empty('No volunteers yet.') : h('div.list', snap.docs.map((d) => {
    const e = d.data();
    return h('div.list-item', h('span.dot'), h('div.grow', link(`/user/${e.uid}`, e.name || e.uid),
      h('div.muted.small', `${Math.round(e.distanceM || 0)} m away when joining · ${ago(e.createdAt)}`)),
    h('button.btn.btn-sm', { onclick: async (ev) => {
      if (!await confirmDialog('Remove volunteer?', `${e.name} can no longer edit this masjid.`, { danger: true, ok: 'Remove' })) return;
      await act(ev.currentTarget, async () => {
        await deleteDoc(d.ref);
        await logAction('editor.remove', `masjids/${m.id}/editors/${d.id}`, { name: e.name });
      }, 'Removed.');
      ev.target.closest('.list-item')?.remove();
    } }, 'Remove'));
  })));
  return c;
}

// ------------------------------------------------------------------ history
async function historyCard(m, reload) {
  const snap = await getDocs(query(collection(db, 'masjids', m.id, 'edits'), orderBy('at', 'desc'), limit(30)));
  return card(`Change history (${snap.size})`, snap.empty ? empty('No changes recorded.') : h('div.list', snap.docs.map((d) => {
    const e = d.data();
    return h('div.list-item', h('span.dot'), h('div.grow',
      h('div', h('b', e.name || 'Someone'), ` changed ${e.field}`), h('div.muted.small', ago(e.at)), describe(e)),
    h('button.btn.btn-sm', { title: 'Put back what it was before this change', onclick: (ev) => undo(ev.currentTarget, m, e, reload) }, icon('undo', 15), 'Undo'));
  })));
}

function describe(e) {
  const show = (v) => (v && typeof v === 'object' ? Object.entries(v).filter(([, x]) => x != null && x !== '')
    .map(([k, x]) => `${k}: ${typeof x === 'object' ? (x.name || JSON.stringify(x)) : x}`).join(' · ') : `${v ?? ''}`);
  return h('div.small', h('span.muted', 'before '), show(e.before) || '–', h('br'), h('span.muted', 'after '), show(e.after) || '–');
}

async function undo(btn, m, e, reload) {
  if (!await confirmDialog('Undo this change?', `The ${e.field} goes back to what it was before ${e.name || 'this'} changed it.`, { ok: 'Undo' })) return;
  const b = e.before || {};
  const changes = e.field === 'location'
    ? locationChange(+b.lat, +b.lng, `${b.district || ''}`, `${b.thana || ''}`, m.country)
    : { [e.field]: b, ...(e.field === 'jamat' ? { hasJamat: Object.keys(b).length > 0 } : {}) };
  await act(btn, () => loggedUpdate(m, e.field, e.after || {}, b, changes), 'Change undone.');
  reload();
}

// ------------------------------------------------------------------ reports
async function reportsCard(m, reload) {
  const snap = await getDocs(query(collection(db, 'reports'), where('masjidId', '==', m.id), limit(20)));
  const open = snap.docs.filter((d) => d.data().status === 'open');
  return card(`Problem reports (${open.length} open)`, snap.empty ? empty('No reports.') : h('div.list', snap.docs.map((d) => {
    const r = d.data();
    return h('div.list-item', h('span.dot'), h('div.grow',
      h('div', h('b', REASONS[r.reason] || r.reason), ' ', statusBadge(r.status)),
      r.note ? h('div.small', `“${r.note}”`) : null,
      h('div.muted.small', `${r.userName || 'User'} · ${ago(r.createdAt)}`)),
    r.status === 'open' ? h('button.btn.btn-sm.btn-ok', { onclick: (ev) => act(ev.currentTarget, async () => {
      await updateDoc(d.ref, { status: 'resolved', resolvedBy: me.uid, resolvedAt: serverTimestamp() });
      await logAction('report.resolve', `reports/${d.id}`, { masjid: m.name });
    }, 'Resolved.').then(reload) }, 'Resolve') : null);
  })));
}

// ------------------------------------------------------------------ notices
async function noticesCard(m) {
  const snap = await getDocs(query(collection(db, 'notices'), where('masjidId', '==', m.id), orderBy('createdAt', 'desc'), limit(20)));
  return card(`Notices (${snap.size})`, snap.empty ? empty('No notices.') : h('div.list', snap.docs.map((d) => {
    const n = d.data();
    return h('div.list-item', h('span.dot'), h('div.grow', h('b', n.title || ''), h('div.muted.small', `${n.category || ''} · ${ago(n.createdAt)}`),
      n.body ? h('div.small', n.body) : null),
    h('button.icon-btn', { title: 'Delete notice', onclick: async (ev) => {
      const row = ev.target.closest('.list-item');
      if (!await confirmDialog('Delete notice?', n.title, { danger: true, ok: 'Delete' })) return;
      await act(null, async () => { await deleteDoc(d.ref); await logAction('notice.delete', `notices/${d.id}`, { title: n.title }); }, 'Deleted.');
      row?.remove();
    } }, icon('trash', 18)));
  })));
}

// ------------------------------------------------------------------ channel
async function channelCard(m) {
  const [members, msgs] = await Promise.all([
    getDocs(query(collection(db, 'masjids', m.id, 'members'), limit(200))),
    getDocs(query(collection(db, 'masjids', m.id, 'messages'), orderBy('createdAt', 'desc'), limit(20))),
  ]);
  const roleSel = (d) => {
    const s = select([['member', 'Member'], ['editor', 'Editor'], ['admin', 'Admin']], d.data().role, { style: { width: 'auto' } });
    s.onchange = () => act(null, async () => {
      await updateDoc(d.ref, { role: s.value });
      await logAction('channel.role', d.ref.path, { role: s.value });
    }, 'Role changed.');
    return s;
  };
  return card(`Channel – ${num(members.size)} members`,
    members.empty ? empty('Nobody joined yet.') : table([
      { label: 'Member', cell: (d) => link(`/user/${d.id}`, d.data().name || d.id) },
      { label: 'Joined', class: 'nowrap', cell: (d) => ago(d.data().joinedAt) },
      { label: 'Role', cell: roleSel },
    ], members.docs.slice(0, 50)),
    h('h3', { style: { margin: '16px 0 6px', fontSize: '15px' } }, 'Latest messages'),
    msgs.empty ? empty('No messages.') : h('div.list', msgs.docs.map((d) => {
      const x = d.data();
      return h('div.list-item', h('span.dot'), h('div.grow',
        h('div', h('b', x.authorName || ''), h('span.muted.small', ` · ${ago(x.createdAt)}`)),
        h('div.small', x.text || (x.attachment ? `📎 ${x.attachment.name}` : ''))),
      h('button.icon-btn', { title: 'Delete message', onclick: async (ev) => {
        const row = ev.target.closest('.list-item');
        if (!await confirmDialog('Delete message?', x.text || 'Attachment', { danger: true, ok: 'Delete' })) return;
        await act(null, async () => {
          const chunks = await getDocs(collection(d.ref, 'chunks'));
          const b = writeBatch(db);
          chunks.docs.forEach((c) => b.delete(c.ref));
          b.delete(d.ref);
          await b.commit();
          await logAction('channel.delete', d.ref.path, { text: (x.text || '').slice(0, 80) });
        }, 'Deleted.');
        row?.remove();
      } }, icon('trash', 18)));
    })));
}

// ------------------------------------------------------------------ danger
function dangerCard(m) {
  return card('Danger zone',
    h('p.muted.small', 'Suspend hides it from the app but keeps everything. Delete removes the masjid, its volunteers, history and channel for good.'),
    h('div.row', h('button.btn.btn-danger', { onclick: async (e) => {
      const typed = input({ placeholder: m.name });
      const ok = await dialog({
        title: 'Delete masjid permanently?',
        body: h('div', h('p', 'This cannot be undone. Type the masjid name to confirm.'), typed),
        actions: [{ label: 'Cancel', value: false }, { label: 'Delete forever', kind: 'danger', run: () => (typed.value.trim() === m.name ? true : (toast('Type the exact name.', 'bad'), false)) }],
      });
      if (!ok) return;
      const done = await act(e.currentTarget, async () => {
        for (const sub of ['editors', 'edits', 'members']) {
          const s = await getDocs(collection(db, 'masjids', m.id, sub));
          for (let i = 0; i < s.docs.length; i += 400) {
            const b = writeBatch(db);
            s.docs.slice(i, i + 400).forEach((d) => b.delete(d.ref));
            await b.commit();
          }
        }
        const msgs = await getDocs(collection(db, 'masjids', m.id, 'messages'));
        for (const d of msgs.docs) {
          const ch = await getDocs(collection(d.ref, 'chunks'));
          const b = writeBatch(db);
          ch.docs.forEach((c) => b.delete(c.ref));
          b.delete(d.ref);
          await b.commit();
        }
        await deleteDoc(doc(db, 'masjids', m.id));
        await logAction('masjid.delete', `masjids/${m.id}`, { name: m.name });
        return true;
      }, 'Masjid deleted.');
      if (done) go('#/masjids');
    } }, icon('trash', 16), 'Delete masjid')));
}
