// Admin log: every action taken in this website, newest first.
import { db, collection, query, orderBy, limit, startAfter, getDocs } from '../fb.js';
import { h, card, table, badge, act, fmtDate, clear, spinner, link } from '../ui.js';
import { pageHead } from '../app.js';

export async function render(el) {
  el.append(pageHead('Admin log', 'Who did what in the admin panel'));
  const out = h('div', spinner());
  el.append(card(null, out));
  let rows = [], cursor = null;
  const target = (t = '') => {
    const [col, id] = t.split('/');
    if (col === 'masjids' && id) return link(`/masjid/${id}`, 'masjid');
    if (col === 'users' && id) return link(`/user/${id}`, 'user');
    return h('span.muted.small', t);
  };
  const load = async () => {
    const s = await getDocs(query(collection(db, 'adminLog'), orderBy('at', 'desc'), ...(cursor ? [startAfter(cursor)] : []), limit(50)));
    cursor = s.docs[s.docs.length - 1] || null;
    rows = rows.concat(s.docs);
    clear(out).append(table([
      { label: 'When', class: 'nowrap', cell: (d) => fmtDate(d.data().at) },
      { label: 'Admin', cell: (d) => d.data().name || d.data().uid },
      { label: 'Action', cell: (d) => badge(d.data().action, 'gold') },
      { label: 'On', cell: (d) => target(d.data().target) },
      { label: 'Details', cell: (d) => h('span.small', Object.entries(d.data().details || {})
        .filter(([, v]) => v != null && v !== '' && typeof v !== 'object').map(([k, v]) => `${k}: ${v}`).join(' · ')) },
    ], rows, { emptyText: 'No admin actions yet.' }),
    s.docs.length === 50 ? h('div.pager', h('button.btn', { onclick: (e) => act(e.currentTarget, load) }, 'Load more')) : null);
  };
  await load();
}
