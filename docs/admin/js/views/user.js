// One user: profile, role and blocks, account actions (through the job
// queue), a direct notification, and everything they did in the app.
import {
  db, me, collection, collectionGroup, doc, getDoc, getDocs, query, where, orderBy,
  limit, updateDoc, logAction,
} from '../fb.js';
import {
  h, icon, card, badge, input, field, dialog, act, ago, fmtDate, toast, clear, empty,
  link, confirmDialog, table, statusBadge, num,
} from '../ui.js';
import { pageHead } from '../app.js';
import { masjidOf, queueJob, REASONS } from '../data.js';

export async function render(el, uid) {
  const snap = await getDoc(doc(db, 'users', uid));
  if (!snap.exists()) {
    el.append(pageHead('User not found'), card(null, empty('No profile – the account may have been deleted.')));
    return;
  }
  const u = snap.data();
  const reload = () => { clear(el); render(el, uid); };
  const isMe = uid === me.uid;
  const admin = u.role === 'superAdmin';

  el.append(pageHead(u.name || '(no name)', u.email || '',
    h('button.btn', { onclick: () => history.back() }, icon('back', 18), 'Back')));

  const left = h('div'), right = h('div');
  el.append(h('div.grid.g2', left, right));

  // ---- profile
  left.append(card('Profile', h('dl.kv',
    h('dt', 'Name'), h('dd', u.name || '–'),
    h('dt', 'Email'), h('dd', u.email || '–'),
    h('dt', 'Phone'), h('dd', u.phone || '–'),
    h('dt', 'Role'), h('dd', admin ? badge('super admin', 'gold') : badge('user', 'mute')),
    h('dt', 'Sign-in'), h('dd', u.disabled ? badge('disabled', 'bad') : badge('active', 'ok')),
    h('dt', 'Volunteering'), h('dd', u.editBlocked ? badge('blocked', 'warn') : badge('allowed', 'ok')),
    h('dt', 'Joined'), h('dd', fmtDate(u.createdAt)),
    h('dt', 'Notifications'), h('dd', `${(u.fcmTokens || []).length} phone(s) registered`),
    h('dt', 'Follows'), h('dd', `${num(Object.keys(u.follows || {}).length)} masjids`),
    h('dt', 'User id'), h('dd', h('code', uid)))));

  // ---- actions
  const b = (label, kind, fn) => h(`button.btn${kind ? `.btn-${kind}` : ''}`, { onclick: (e) => fn(e.currentTarget) }, label);
  const set = async (btn, data, action, msg) => {
    await act(btn, async () => { await updateDoc(snap.ref, data); await logAction(action, `users/${uid}`, { email: u.email, ...data }); }, msg);
    reload();
  };
  left.append(card('Manage',
    h('p.muted.small', 'Blocking volunteering stops them editing masjid times. Disabling sign-in locks them out of the app (within an hour on phones already signed in). Deleting removes the account and profile for good.'),
    h('div.row',
      isMe ? null : b(admin ? 'Remove super admin' : 'Make super admin', '', async (btn) => {
        if (!await confirmDialog(admin ? 'Remove super admin?' : 'Make super admin?',
          admin ? `${u.email} loses access to this panel.` : `${u.email} gets full control of the app and this panel.`, { ok: 'Yes', danger: !admin })) return;
        set(btn, { role: admin ? 'user' : 'superAdmin' }, admin ? 'user.demote' : 'user.promote', 'Role changed.');
      }),
      b(u.editBlocked ? 'Allow volunteering' : 'Block volunteering', '', (btn) =>
        set(btn, { editBlocked: !u.editBlocked }, u.editBlocked ? 'user.unblock' : 'user.block', 'Saved.')),
      isMe ? null : b(u.disabled ? 'Enable sign-in' : 'Disable sign-in', u.disabled ? 'ok' : '', async (btn) => {
        if (!u.disabled && !await confirmDialog('Disable sign-in?', `${u.email} will be signed out and can't sign in until you enable it again.`, { danger: true, ok: 'Disable' })) return;
        await act(btn, async () => {
          const { started } = await queueJob(u.disabled ? 'enableUser' : 'disableUser', { uid, email: u.email });
          toast(started ? 'Working on it – refresh in a minute.' : 'Queued – runs with the next job (add a GitHub token in Settings to run instantly).');
        });
      }),
      isMe ? null : b('Delete account', 'danger', async (btn) => {
        const typed = input({ placeholder: u.email });
        const ok = await dialog({
          title: 'Delete this account?',
          body: h('div', h('p', 'The sign-in account and profile are deleted for good. Masjids they own stay (transfer them first if needed). Type their email to confirm.'), typed),
          actions: [{ label: 'Cancel', value: false }, { label: 'Delete', kind: 'danger', run: () => (typed.value.trim() === u.email ? true : (toast('Type the exact email.', 'bad'), false)) }],
        });
        if (!ok) return;
        await act(btn, async () => {
          const { started } = await queueJob('deleteUser', { uid, email: u.email });
          toast(started ? 'Deleting – it takes about a minute.' : 'Queued – runs with the next job.');
        });
      }))));

  // ---- direct message
  const title = input({ value: 'Muslimin', maxLength: 120 });
  const body = h('textarea.inp', { placeholder: 'Message to this user…', maxLength: 500 });
  left.append(card('Send a notification to this user',
    (u.fcmTokens || []).length ? null : h('div.msg.warn', 'This user has no phone registered for notifications.'),
    field('Title', title), field('Message', body),
    h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
      if (!body.value.trim()) throw new Error('Write a message.');
      const { started } = await queueJob('push', { target: { type: 'user', id: uid }, title: title.value.trim(), body: body.value.trim() });
      toast(started ? 'Sending now.' : 'Queued.');
      body.value = '';
    }) }, icon('send', 16), 'Send'))));

  // ---- their activity (loaded after)
  const sections = [
    ['Masjids they own', () => getDocs(query(collection(db, 'masjids'), where('ownerUid', '==', uid), limit(50))),
      (s) => table([
        { label: 'Masjid', cell: (d) => masjidOf(d).name },
        { label: 'Area', cell: (d) => `${d.data().thana || ''}, ${d.data().district || ''}` },
        { label: 'Status', cell: (d) => statusBadge(d.data().status) },
      ], s.docs, { onRow: (d) => { location.hash = `#/masjid/${d.id}`; }, emptyText: 'None.' })],
    ['Volunteer editor of', () => getDocs(query(collectionGroup(db, 'editors'), where('uid', '==', uid), limit(50))),
      (s) => (s.empty ? empty('None.') : h('div.list', s.docs.map((d) => h('div.list-item', h('span.dot'),
        h('div.grow', link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid'), h('div.muted.small', `since ${ago(d.data().createdAt)}`))))))],
    ['Their changes', () => getDocs(query(collectionGroup(db, 'edits'), where('uid', '==', uid), orderBy('at', 'desc'), limit(20))),
      (s) => (s.empty ? empty('None.') : h('div.list', s.docs.map((d) => h('div.list-item', h('span.dot'),
        h('div.grow', h('div', `${d.data().field} of `, link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'masjid')), h('div.muted.small', ago(d.data().at)))))))],
    ['Channels joined', () => getDocs(query(collectionGroup(db, 'members'), where('uid', '==', uid), limit(50))),
      (s) => (s.empty ? empty('None.') : h('div.list', s.docs.map((d) => h('div.list-item', h('span.dot'),
        h('div.grow', link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid'), ' ', badge(d.data().role, 'mute')))))) ],
    ['Problem reports', () => getDocs(query(collection(db, 'reports'), where('uid', '==', uid), limit(30))),
      (s) => (s.empty ? empty('None.') : h('div.list', s.docs.map((d) => h('div.list-item', h('span.dot'),
        h('div.grow', link(`/masjid/${d.data().masjidId}`, d.data().masjidName || 'Masjid'), ` – ${REASONS[d.data().reason] || d.data().reason} `, statusBadge(d.data().status),
          d.data().note ? h('div.small', `“${d.data().note}”`) : null)))))],
    ['Masjids they suggested', () => getDocs(query(collection(db, 'suggestions'), where('uid', '==', uid), limit(30))),
      (s) => (s.empty ? empty('None.') : h('div.list', s.docs.map((d) => h('div.list-item', h('span.dot'),
        h('div.grow', h('b', d.data().name), ' ', statusBadge(d.data().status), h('div.muted.small', ago(d.data().createdAt)))))))],
  ];
  for (const [title2, load, view] of sections) {
    const c = card(title2, h('div.spin-wrap', h('div.spinner')));
    right.append(c);
    load().then((s) => { c.lastChild.replaceWith(view(s)); })
      .catch((e) => { console.warn(e); c.lastChild.replaceWith(empty('Could not load (index still building?).')); });
  }
}
