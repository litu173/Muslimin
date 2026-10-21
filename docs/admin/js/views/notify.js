// Notifications: write once, send to everyone, a masjid's followers, a
// channel or one person; see what was sent and how it went.
import {
  db, collection, query, where, orderBy, limit, getDocs, deleteDoc, doc, logAction,
} from '../fb.js';
import {
  h, icon, card, table, badge, statusBadge, input, select, field, act, ago, clear, toast,
  confirmDialog, spinner, empty,
} from '../ui.js';
import { pageHead } from '../app.js';
import { queueJob, startJobs, ghToken, masjidOf } from '../data.js';

export async function render(el) {
  el.append(pageHead('Notifications', 'Send a message to the phones of Muslimin users'));
  const grid = h('div.grid.g2');
  el.append(grid);
  grid.append(compose(), preview());
  const hist = h('div');
  el.append(hist);
  history(hist);
}

// shared between the form and the preview
const form = {};

function compose() {
  form.to = select([
    ['all', 'Everyone (all users)'],
    ['masjid', "One masjid's followers"],
    ['channel', "One masjid's channel members"],
    ['user', 'One person (by email)'],
  ], 'all');
  form.hint = h('div.muted.small', { style: { marginBottom: '12px' } }, 'To message several people (e.g. inactive users), pick them under Users.');
  form.kind = select([['news', 'News / announcement'], ['update', 'App update (opens About the App)']], 'news');
  form.save = h('input', { type: 'checkbox', checked: true });
  form.title = input({ placeholder: 'e.g. মুসলিমিন আপডেট এসেছে 🎉', maxLength: 120 });
  form.body = h('textarea.inp', { placeholder: 'Your message…', maxLength: 500 });
  form.who = input({ placeholder: 'Search masjid by name…' });
  form.email = input({ type: 'email', placeholder: 'person@email.com' });
  const results = h('div.list');
  let picked = null;
  const pickedTxt = h('div.small.muted');

  const allBox = h('div', field('Type', form.kind),
    h('label.switch', form.save, 'Also show it on the app\'s Notifications page'));
  const masjidBox = h('div', field('Masjid', form.who), results, pickedTxt);
  const userBox = h('div', field('Their account email', form.email));
  const sync = () => {
    allBox.hidden = form.to.value !== 'all';
    masjidBox.hidden = !['masjid', 'channel'].includes(form.to.value);
    userBox.hidden = form.to.value !== 'user';
    form.onChange?.();
  };
  form.to.onchange = sync;
  let t;
  form.who.oninput = () => {
    clearTimeout(t);
    t = setTimeout(async () => {
      const q = form.who.value.trim().toLowerCase();
      clear(results);
      if (q.length < 2) return;
      const s = await getDocs(query(collection(db, 'masjids'), where('status', '==', 'approved'), orderBy('nameLower'),
        where('nameLower', '>=', q), where('nameLower', '<=', `${q}`), limit(6)));
      results.append(s.docs.map((d) => {
        const m = masjidOf(d);
        return h('div.list-item', { style: { cursor: 'pointer' }, onclick: () => {
          picked = m; clear(results); form.who.value = m.name;
          pickedTxt.textContent = `Selected: ${m.name} (${m.thana || ''}, ${m.district || ''})`;
        } }, h('span.dot'), h('div.grow', h('b', m.name), h('div.muted.small', `${m.thana || ''}, ${m.district || ''}`)));
      }));
    }, 300);
  };
  [form.title, form.body, form.kind].forEach((x) => { x.oninput = () => form.onChange?.(); x.onchange = () => form.onChange?.(); });

  const send = h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
    const title = form.title.value.trim(), body = form.body.value.trim();
    if (!title || !body) throw new Error('Write a title and a message.');
    const target = { type: form.to.value };
    let who = 'every Muslimin user';
    if (['masjid', 'channel'].includes(target.type)) {
      if (!picked) throw new Error('Pick the masjid.');
      target.id = picked.id;
      who = `${target.type === 'masjid' ? 'followers' : 'channel members'} of ${picked.name}`;
    }
    if (target.type === 'user') {
      const e2 = form.email.value.trim();
      const s = await getDocs(query(collection(db, 'users'), where('email', '==', e2), limit(1)));
      if (s.empty) throw new Error('No account with that email.');
      target.id = s.docs[0].id;
      who = e2;
    }
    if (!await confirmDialog('Send this notification?', `To ${who}: “${title}” – ${body}`, { ok: 'Send now' })) return;
    const { started } = await queueJob('push', { target, title, body, kind: form.kind.value, save: form.save.checked });
    toast(started ? 'Sending – results appear below in a minute.' : 'Queued. Add a GitHub token in Settings to send instantly; otherwise it goes with the next scheduled run.');
    form.body.value = ''; form.onChange?.();
  }) }, icon('send', 16), 'Send notification');

  sync();
  return card('Write',
    field('Send to', form.to), form.hint, allBox, masjidBox, userBox,
    field('Title', form.title), field('Message', form.body, 'Up to 500 characters. Bangla works.'),
    ghToken.get() ? null : h('div.msg.warn', 'No GitHub token saved – messages wait for the next scheduled run (up to ~15 min, sometimes later). Add one in App settings to send instantly.'),
    h('div.row.end', send));
}

function preview() {
  const t = h('b'), b = h('span');
  const draw = () => {
    t.textContent = form.title.value || 'Title';
    b.textContent = form.body.value || 'Your message appears here.';
  };
  form.onChange = draw;
  draw();
  return card('Preview',
    h('div.preview-phone', h('div.small', { style: { opacity: 0.6, marginBottom: '8px' } }, 'Notification on a phone'),
      h('div.pn', h('img', { src: '../assets/icon-192.png', alt: '' }), h('div', h('div.small', { style: { opacity: 0.7 } }, 'Muslimin · now'), t, b))),
    h('p.muted.small', { style: { marginTop: '12px' } },
      'Tapping it opens the app – an "App update" opens About the App; a masjid message opens that masjid; a message to a person opens their Notifications page, where it stays. Messages to everyone are also listed there when the switch is on.'));
}

async function history(box) {
  clear(box).append(spinner());
  const [jobs, news] = await Promise.all([
    getDocs(query(collection(db, 'adminJobs'), orderBy('createdAt', 'desc'), limit(25))).catch(() => null),
    getDocs(query(collection(db, 'announcements'), orderBy('createdAt', 'desc'), limit(25))).catch(() => null),
  ]);
  const queued = jobs?.docs.some((d) => d.data().status === 'queued');
  clear(box).append(
    card(h('div.row', h('h2', 'Sent and queued'), h('div.grow'),
      queued ? h('button.btn.btn-sm', { onclick: (e) => act(e.currentTarget, async () => {
        toast((await startJobs()) ? 'Started – refresh in a minute.' : 'Add a GitHub token in App settings first.');
      }) }, 'Run queued now') : null,
      h('button.btn.btn-sm', { onclick: () => history(box) }, icon('refresh', 15), 'Refresh')),
    !jobs || jobs.empty ? empty('Nothing sent from here yet.') : table([
      { label: 'What', cell: (d) => (d.data().type === 'push'
        ? h('div.t-name', h('b', d.data().payload?.title || ''), h('span', d.data().payload?.body || ''))
        : h('b', { disableUser: 'Disable sign-in', enableUser: 'Enable sign-in', deleteUser: 'Delete account', numberMasjids: 'Number the masjids' }[d.data().type] || d.data().type, d.data().payload?.email ? ` – ${d.data().payload.email}` : '')) },
      { label: 'To', cell: (d) => {
        const t = d.data().payload?.target;
        if (d.data().type !== 'push') return '';
        return badge(t?.type === 'users' ? `${t.ids?.length || 0} people` : t?.type || 'all', 'mute');
      } },
      { label: 'Status', cell: (d) => h('div', statusBadge(d.data().status), d.data().result ? h('div.muted.small', d.data().result) : null) },
      { label: 'When', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
    ], jobs.docs)),
    card('On the app\'s Notifications page', !news || news.empty ? empty('No announcements.') : table([
      { label: 'Announcement', cell: (d) => h('div.t-name', h('b', d.data().title), h('span', d.data().body)) },
      { label: 'Type', cell: (d) => badge(d.data().type || 'news', 'gold') },
      { label: 'When', class: 'nowrap', cell: (d) => ago(d.data().createdAt) },
      { label: '', class: 'r', cell: (d) => h('button.icon-btn', { title: 'Remove from the app', onclick: async () => {
        if (!await confirmDialog('Remove announcement?', 'It disappears from everyone\'s Notifications page (already-sent push messages stay on phones).', { danger: true, ok: 'Remove' })) return;
        await act(null, async () => { await deleteDoc(doc(db, 'announcements', d.id)); await logAction('announcement.delete', `announcements/${d.id}`, { title: d.data().title }); }, 'Removed.');
        history(box);
      } }, icon('trash', 18)) },
    ], news.docs)));
}
