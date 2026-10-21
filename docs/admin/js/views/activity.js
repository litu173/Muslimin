// Activity across the whole app: changes (with undo), notices, volunteers
// and channel messages – with moderation.
import {
  db, collection, collectionGroup, doc, getDoc, getDocs, query, orderBy, limit,
  deleteDoc, writeBatch, logAction,
} from '../fb.js';
import {
  h, icon, card, table, badge, act, go, ago, clear, tabs, spinner, link, confirmDialog, empty,
} from '../ui.js';
import { pageHead } from '../app.js';
import { masjidOf, loggedUpdate, locationChange } from '../data.js';

export async function render(el, tab = 'edits') {
  el.append(pageHead('Activity', 'What people are doing in the app'));
  el.append(tabs([['edits', 'Changes'], ['notices', 'Notices'], ['messages', 'Channel messages'], ['editors', 'Volunteers']],
    tab, (t) => go(`#/activity/${t}`)));
  const body = h('div', spinner());
  el.append(body);
  const again = () => { clear(el); render(el, tab); };
  await ({ edits, notices, messages, editors }[tab] || edits)(body, again);
}

async function edits(body, again) {
  const s = await getDocs(query(collectionGroup(db, 'edits'), orderBy('at', 'desc'), limit(60)));
  clear(body).append(card(null, table([
    { label: 'Who', cell: (d) => link(`/user/${d.data().uid}`, d.data().name || 'Someone') },
    { label: 'Changed', cell: (d) => badge(d.data().field, 'gold') },
    { label: 'Masjid', cell: (d) => link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid') },
    { label: 'When', class: 'nowrap', cell: (d) => ago(d.data().at) },
    { label: '', class: 'r', cell: (d) => h('button.btn.btn-sm', { title: 'Put back the value from before this change', onclick: async (e) => {
      const btn = e.currentTarget;
      const x = d.data();
      if (!await confirmDialog('Undo this change?', `${x.field} of ${x.masjidName} goes back to what it was before ${x.name} changed it.`, { ok: 'Undo' })) return;
      await act(btn, async () => {
        const ms = await getDoc(doc(db, 'masjids', x.masjidId));
        if (!ms.exists()) throw new Error('The masjid no longer exists.');
        const m = masjidOf(ms);
        const b = x.before || {};
        await loggedUpdate(m, x.field, x.after || {}, b, x.field === 'location'
          ? locationChange(+b.lat, +b.lng, `${b.district || ''}`, `${b.thana || ''}`, m.country)
          : { [x.field]: b, ...(x.field === 'jamat' ? { hasJamat: Object.keys(b).length > 0 } : {}) });
      }, 'Undone.');
      again();
    } }, icon('undo', 15), 'Undo') },
  ], s.docs, { emptyText: 'No changes yet.' })));
}

async function notices(body, again) {
  const s = await getDocs(query(collection(db, 'notices'), orderBy('createdAt', 'desc'), limit(60)));
  clear(body).append(card(null, table([
    { label: 'Notice', cell: (d) => h('div.t-name', h('b', d.data().title || ''), h('span', (d.data().body || '').slice(0, 120))) },
    { label: 'Type', cell: (d) => badge(d.data().category || 'notice', 'mute') },
    { label: 'Masjid', cell: (d) => link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid') },
    { label: 'Posted', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
    { label: '', class: 'r', cell: (d) => h('button.icon-btn', { title: 'Delete', onclick: async (e) => {
      e.stopPropagation();
      if (!await confirmDialog('Delete notice?', d.data().title, { danger: true, ok: 'Delete' })) return;
      await act(null, async () => { await deleteDoc(d.ref); await logAction('notice.delete', `notices/${d.id}`, { title: d.data().title }); }, 'Deleted.');
      again();
    } }, icon('trash', 18)) },
  ], s.docs, { emptyText: 'No notices yet.' })));
}

async function messages(body, again) {
  const s = await getDocs(query(collectionGroup(db, 'messages'), orderBy('createdAt', 'desc'), limit(60)));
  clear(body).append(card(null, table([
    { label: 'Message', cell: (d) => h('div.t-name', h('b', d.data().authorName || ''), h('span', d.data().text || (d.data().attachment ? `📎 ${d.data().attachment.name}` : ''))) },
    { label: 'Channel', cell: (d) => link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid') },
    { label: 'Sent', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
    { label: '', class: 'r', cell: (d) => h('button.icon-btn', { title: 'Delete', onclick: async () => {
      if (!await confirmDialog('Delete message?', d.data().text || 'Attachment', { danger: true, ok: 'Delete' })) return;
      await act(null, async () => {
        const ch = await getDocs(collection(d.ref, 'chunks'));
        const b = writeBatch(db);
        ch.docs.forEach((c) => b.delete(c.ref));
        b.delete(d.ref);
        await b.commit();
        await logAction('channel.delete', d.ref.path, { text: (d.data().text || '').slice(0, 80) });
      }, 'Deleted.');
      again();
    } }, icon('trash', 18)) },
  ], s.docs, { emptyText: 'No channel messages yet.' })));
}

async function editors(body) {
  const s = await getDocs(query(collectionGroup(db, 'editors'), orderBy('createdAt', 'desc'), limit(100)));
  clear(body).append(card(null, s.empty ? empty('No volunteers yet.') : table([
    { label: 'Volunteer', cell: (d) => link(`/user/${d.data().uid}`, d.data().name || d.data().uid) },
    { label: 'Masjid', cell: (d) => link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid') },
    { label: 'Distance', class: 'r', cell: (d) => `${Math.round(d.data().distanceM || 0)} m` },
    { label: 'Since', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
  ], s.docs)));
}
