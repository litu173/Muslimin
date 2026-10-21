// Users: newest first, search by email or name, filter admins / blocked.
import {
  db, collection, query, where, orderBy, limit, startAfter, getDocs,
} from '../fb.js';
import { h, icon, card, table, badge, input, select, act, go, ago, clear, spinner, num } from '../ui.js';
import { pageHead } from '../app.js';

const PAGE = 50;

export async function render(el) {
  el.append(pageHead('Users', 'Everyone with a Muslimin account'));
  const q = input({ placeholder: 'Search by email or name…' });
  const kind = select([['', 'Everyone'], ['admin', 'Super admins'], ['blocked', 'Blocked from editing'], ['disabled', 'Sign-in disabled']], '');
  const out = h('div');
  el.append(card(null,
    h('div.filters', h('div.search', icon('search'), q), kind),
    h('div.muted.small', 'Search matches the start of the email, or the start of the name (exact capitals).'),
    out));

  let cursor = null, rows = [], timer;
  const apply = () => { cursor = null; rows = []; load(); };
  q.oninput = () => { clearTimeout(timer); timer = setTimeout(apply, 350); };
  kind.onchange = apply;

  async function load(more = false) {
    if (!more) clear(out).append(spinner());
    const users = collection(db, 'users');
    const text = q.value.trim();
    let queries;
    if (text) {
      const e = text.toLowerCase();
      queries = [
        query(users, orderBy('email'), where('email', '>=', e), where('email', '<=', `${e}`), limit(25)),
        query(users, orderBy('name'), where('name', '>=', text), where('name', '<=', `${text}`), limit(25)),
      ];
    } else {
      const c = [];
      if (kind.value === 'admin') c.push(where('role', '==', 'superAdmin'));
      else if (kind.value === 'blocked') c.push(where('editBlocked', '==', true));
      else if (kind.value === 'disabled') c.push(where('disabled', '==', true));
      else c.push(orderBy('createdAt', 'desc'));
      if (more && cursor) c.push(startAfter(cursor));
      queries = [query(users, ...c, limit(PAGE))];
    }
    await act(null, async () => {
      const snaps = await Promise.all(queries.map(getDocs));
      const seen = new Set(rows.map((r) => r.id));
      for (const s of snaps) for (const d of s.docs) if (!seen.has(d.id)) { seen.add(d.id); rows.push(d); }
      cursor = !text ? snaps[0].docs[snaps[0].docs.length - 1] || null : null;
      draw(!text && snaps[0].docs.length === PAGE);
    });
  }

  function draw(hasMore) {
    clear(out).append(
      h('div.muted.small', { style: { margin: '6px 0 10px' } }, `${num(rows.length)} shown`),
      table([
        { label: 'Name', cell: (d) => h('div.t-name', h('b', d.data().name || '(no name)'), h('span', d.data().email || '')) },
        { label: 'Role', cell: (d) => (d.data().role === 'superAdmin' ? badge('super admin', 'gold') : badge('user', 'mute')) },
        { label: 'Status', cell: (d) => h('div.row', d.data().disabled ? badge('sign-in disabled', 'bad') : badge('active', 'ok'), d.data().editBlocked ? badge('no editing', 'warn') : null) },
        { label: 'Follows', class: 'r', cell: (d) => num(Object.keys(d.data().follows || {}).length) },
        { label: 'Push', cell: (d) => ((d.data().fcmTokens || []).length ? badge(`${d.data().fcmTokens.length} phone${d.data().fcmTokens.length > 1 ? 's' : ''}`, 'ok') : badge('off', 'mute')) },
        { label: 'Joined', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
      ], rows, { onRow: (d) => go(`#/user/${d.id}`), emptyText: 'No users match.' }),
      hasMore ? h('div.pager', h('button.btn', { onclick: (e) => act(e.currentTarget, () => load(true)) }, 'Load more')) : null);
  }
  load();
}
