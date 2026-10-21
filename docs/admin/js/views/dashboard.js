// Dashboard: the numbers that matter and what happened lately.
import {
  db, collection, collectionGroup, query, where, orderBy, limit, getDocs,
  getCountFromServer, Timestamp,
} from '../fb.js';
import { h, icon, card, num, ago, link, go, statusBadge, empty } from '../ui.js';
import { pageHead } from '../app.js';
import { REASONS } from '../data.js';

const count = async (q) => {
  try { return (await getCountFromServer(q)).data().count; } catch (e) { console.warn(e); return null; }
};

export async function render(el) {
  el.append(pageHead('Dashboard', 'Everything happening in Muslimin'));
  const statsEl = h('div.stats');
  el.append(statsEl);

  const masjids = collection(db, 'masjids');
  const week = Timestamp.fromMillis(Date.now() - 7 * 864e5);
  const [users, newUsers, approved, withTimes, pending, reports, suggestions, editors, notices, admins] =
    await Promise.all([
      count(collection(db, 'users')),
      count(query(collection(db, 'users'), where('createdAt', '>=', week))),
      count(query(masjids, where('status', '==', 'approved'))),
      count(query(masjids, where('status', '==', 'approved'), where('hasJamat', '==', true))),
      count(query(masjids, where('status', '==', 'pending'))),
      count(query(collection(db, 'reports'), where('status', '==', 'open'))),
      count(query(collection(db, 'suggestions'), where('status', '==', 'open'))),
      count(collectionGroup(db, 'editors')),
      count(query(collection(db, 'notices'), where('createdAt', '>=', week))),
      count(query(collection(db, 'users'), where('role', '==', 'superAdmin'))),
    ]);
  const pct = approved ? Math.round((withTimes / approved) * 100) : 0;
  const stat = (k, v, d, ic, to, hl) => h(`div.stat${to ? '.click' : ''}${hl ? '.hl' : ''}`, { onclick: to ? () => go(to) : null },
    icon(ic, 22), h('div.k', k), h('div.v', v == null ? '–' : num(v)), d ? h('div.d', d) : null);
  statsEl.append(
    stat('Users', users, `+${num(newUsers)} this week · ${num(admins)} admins`, 'users', '#/users', true),
    stat('Masjids', approved, `${pct}% have jamat times`, 'masjid', '#/masjids'),
    stat('With jamat times', withTimes, `${num((approved || 0) - (withTimes || 0))} still without`, 'check', '#/masjids'),
    stat('Waiting for review', (pending || 0) + (suggestions || 0), `${num(pending)} masjids · ${num(suggestions)} suggested`, 'review', '#/review'),
    stat('Open problem reports', reports, 'from users', 'flag', '#/review/reports'),
    stat('Volunteer editors', editors, 'people keeping times right', 'users', '#/activity/editors'),
    stat('Notices this week', notices, 'from masjids', 'bell', '#/activity/notices'),
  );

  // Recent activity, side by side.
  const grid = h('div.grid.g2');
  el.append(grid);
  const box = (title, to, body) => card(h('div.row', h('h2', title), h('div.grow'), to ? link(to, 'See all →') : null), body);

  const [edits, latestUsers, openReports, latestNotices] = await Promise.all([
    getDocs(query(collectionGroup(db, 'edits'), orderBy('at', 'desc'), limit(6))).catch(() => null),
    getDocs(query(collection(db, 'users'), orderBy('createdAt', 'desc'), limit(6))).catch(() => null),
    getDocs(query(collection(db, 'reports'), where('status', '==', 'open'), orderBy('createdAt', 'desc'), limit(6))).catch(() => null),
    getDocs(query(collection(db, 'notices'), orderBy('createdAt', 'desc'), limit(6))).catch(() => null),
  ]);
  const list = (snap, row) => (!snap || snap.empty ? empty('Nothing yet.') : h('div.list', snap.docs.map(row)));

  grid.append(
    box('Latest changes', '/activity/edits', list(edits, (d) => {
      const e = d.data();
      return h('div.list-item', h('span.dot'), h('div.grow',
        h('div', h('b', e.name || 'Someone'), ` changed ${e.field} of `, link(`/masjid/${e.masjidId}`, e.masjidName || 'a masjid')),
        h('div.muted.small', ago(e.at))));
    })),
    box('New users', '/users', list(latestUsers, (d) => {
      const u = d.data();
      return h('div.list-item.click', { style: { cursor: 'pointer' }, onclick: () => go(`#/user/${d.id}`) },
        h('span.dot'), h('div.grow', h('b', u.name || '(no name)'), h('div.muted.small', `${u.email || ''} · ${ago(u.createdAt)}`)),
        u.role === 'superAdmin' ? statusBadge('admin') : null);
    })),
    box('Open problem reports', '/review/reports', list(openReports, (d) => {
      const r = d.data();
      return h('div.list-item', h('span.dot'), h('div.grow',
        h('div', link(`/masjid/${r.masjidId}`, r.masjidName || 'Masjid'), ' – ', REASONS[r.reason] || r.reason),
        r.note ? h('div.small', `“${r.note}”`) : null,
        h('div.muted.small', `${r.userName || 'User'} · ${ago(r.createdAt)}`)));
    })),
    box('Latest notices', '/activity/notices', list(latestNotices, (d) => {
      const n = d.data();
      return h('div.list-item', h('span.dot'), h('div.grow',
        h('b', n.title || ''), h('div.muted.small', `${n.masjidName || ''} · ${ago(n.createdAt)}`)));
    })),
  );
}
