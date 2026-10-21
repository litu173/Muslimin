// Users: newest first, search by email or name, filter by role / blocked /
// inactive, and message the people picked (push + their Notifications page).
import {
  db, collection, query, where, orderBy, limit, startAfter, getDocs, Timestamp,
} from '../fb.js';
import {
  h, icon, card, table, badge, input, select, act, go, ago, clear, spinner, num, toast,
} from '../ui.js';
import { pageHead } from '../app.js';
import { ROLES, roleName, ROLE_KIND } from '../data.js';
import { messageDialog } from './user.js';

const PAGE = 50;

export async function render(el) {
  el.append(pageHead('Users', 'Everyone with a Muslimin account'));
  const q = input({ placeholder: 'Search by email or name…' });
  const kind = select([
    ['', 'Everyone'],
    ...ROLES.filter(([r]) => r !== 'user').map(([r, label]) => [`role:${r}`, `Role: ${label}`]),
    ['inactive', 'Inactive (not opened the app for…)'],
    ['untracked', 'No activity record yet'],
    ['blocked', 'Blocked from editing'], ['disabled', 'Sign-in disabled'],
  ], '');
  const days = select([[7, '7 days'], [14, '14 days'], [30, '30 days'], [60, '60 days'], [90, '90 days']], 30);
  const out = h('div');
  const note = h('div.muted.small');
  el.append(card(null,
    h('div.filters', h('div.search', icon('search'), q), kind, days),
    note,
    out));

  let cursor = null, rows = [], timer;
  const picked = new Map();
  const apply = () => { cursor = null; rows = []; load(); };
  const syncNote = () => {
    days.hidden = kind.value !== 'inactive';
    note.textContent = {
      inactive: 'People whose app last opened before this – app 1.20 and newer record it. Pick people and message them below.',
      untracked: 'Accounts with no “last opened” record: they have not opened app 1.20 or newer since it came out. Scans pages of newest accounts.',
    }[kind.value] || 'Search matches the start of the email, or the start of the name (exact capitals).';
  };
  q.oninput = () => { clearTimeout(timer); timer = setTimeout(apply, 350); };
  kind.onchange = () => { syncNote(); apply(); };
  days.onchange = apply;
  syncNote();

  async function load(more = false) {
    if (!more) { clear(out).append(spinner()); picked.clear(); }
    const users = collection(db, 'users');
    const text = q.value.trim();
    let queries;
    if (text) {
      const e = text.toLowerCase();
      queries = [
        query(users, orderBy('email'), where('email', '>=', e), where('email', '<=', `${e}`), limit(25)),
        query(users, orderBy('name'), where('name', '>=', text), where('name', '<=', `${text}`), limit(25)),
      ];
    } else {
      const c = [];
      const k = kind.value;
      if (k.startsWith('role:')) c.push(where('role', '==', k.slice(5)));
      else if (k === 'blocked') c.push(where('editBlocked', '==', true));
      else if (k === 'disabled') c.push(where('disabled', '==', true));
      else if (k === 'inactive') {
        const cut = Timestamp.fromMillis(Date.now() - Number(days.value) * 86400000);
        c.push(where('lastSeenAt', '<', cut), orderBy('lastSeenAt', 'asc'));
      } else c.push(orderBy('createdAt', 'desc'));
      if (more && cursor) c.push(startAfter(cursor));
      queries = [query(users, ...c, limit(PAGE))];
    }
    await act(null, async () => {
      const snaps = await Promise.all(queries.map(getDocs));
      const seen = new Set(rows.map((r) => r.id));
      for (const s of snaps) {
        for (const d of s.docs) {
          if (seen.has(d.id)) continue;
          // Firestore can't ask for a missing field – filter the page here.
          if (!text && kind.value === 'untracked' && d.data().lastSeenAt) continue;
          seen.add(d.id); rows.push(d);
        }
      }
      cursor = !text ? snaps[0].docs[snaps[0].docs.length - 1] || null : null;
      draw(!text && snaps[0].docs.length === PAGE);
    });
  }

  const bar = h('div.bulkbar');
  function drawBar() {
    clear(bar).append(
      h('b', `${num(picked.size)} picked`),
      h('div.grow'),
      h('button.btn.btn-sm', { onclick: () => { picked.clear(); draw(lastMore); } }, 'Clear'),
      h('button.btn.btn-sm.btn-primary', { onclick: async () => {
        const sent = await messageDialog([...picked.keys()], `${num(picked.size)} people`);
        if (sent) { picked.clear(); draw(lastMore); }
      } }, icon('send', 15), 'Send message'));
    bar.hidden = picked.size === 0;
  }

  let lastMore = false;
  function draw(hasMore) {
    lastMore = hasMore;
    const all = h('input.chk', { type: 'checkbox', title: 'Pick everyone shown', checked: rows.length > 0 && rows.every((d) => picked.has(d.id)),
      onclick: (e) => { e.stopPropagation(); rows.forEach((d) => (e.target.checked ? picked.set(d.id, d) : picked.delete(d.id))); draw(hasMore); } });
    clear(out).append(
      h('div.row', { style: { margin: '6px 0 10px' } }, all, h('span.muted.small', `${num(rows.length)} shown – tick people to message them`)),
      table([
        { label: '', cell: (d) => h('input.chk', { type: 'checkbox', checked: picked.has(d.id), onclick: (e) => {
          e.stopPropagation();
          if (e.target.checked) picked.set(d.id, d); else picked.delete(d.id);
          drawBar();
        } }) },
        { label: 'Name', cell: (d) => h('div.t-name', h('b', d.data().name || '(no name)'), h('span', d.data().email || '')) },
        { label: 'Role', cell: (d) => badge(roleName(d.data().role).toLowerCase(), ROLE_KIND[d.data().role || 'user']) },
        { label: 'Status', cell: (d) => h('div.row', d.data().disabled ? badge('sign-in disabled', 'bad') : badge('active', 'ok'), d.data().editBlocked ? badge('no editing', 'warn') : null) },
        { label: 'Push', cell: (d) => ((d.data().fcmTokens || []).length ? badge(`${d.data().fcmTokens.length} phone${d.data().fcmTokens.length > 1 ? 's' : ''}`, 'ok') : badge('off', 'mute')) },
        { label: 'Last opened', class: 'nowrap', cell: (d) => (d.data().lastSeenAt ? h('span', ago(d.data().lastSeenAt), h('div.muted.small', `${d.data().platform || ''} ${d.data().appVersion || ''}`)) : h('span.muted', '–')) },
        { label: 'Joined', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
      ], rows, { onRow: (d) => go(`#/user/${d.id}`), emptyText: kind.value === 'inactive' ? 'Nobody inactive that long (among people on app 1.20+).' : 'No users match.' }),
      hasMore ? h('div.pager', h('button.btn', { onclick: (e) => act(e.currentTarget, () => load(true)) }, 'Load more')) : null,
      bar);
    drawBar();
  }
  load().catch((e) => toast(e.message, 'bad'));
}
