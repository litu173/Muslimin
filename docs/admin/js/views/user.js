// One user: profile, role and blocks, account actions (through the job
// queue), a direct notification, and everything they did in the app.
import {
  db, me, isSuper, collection, collectionGroup, doc, getDoc, getDocs, query, where, orderBy,
  limit, updateDoc, logAction,
} from '../fb.js';
import {
  h, icon, card, badge, input, field, dialog, act, ago, fmtDate, toast, clear, empty,
  link, confirmDialog, table, statusBadge, num, select, clear as clearEl,
} from '../ui.js';
import { pageHead } from '../app.js';
import {
  masjidOf, queueJob, REASONS, ROLES, roleName, ROLE_HELP, ROLE_KIND,
} from '../data.js';

/**
 * Message to one or more people: a push to their phones and an entry on
 * their Notifications page, optionally opening a masjid or About the App.
 * Resolves true when queued.
 */
export async function messageDialog(uids, who) {
  const title = input({ value: 'Muslimin', maxLength: 120 });
  const body = h('textarea.inp', { placeholder: 'Your message…', maxLength: 500 });
  const linkType = select([['', 'Nothing – just the message'], ['masjid', 'A masjid'], ['about', 'About the App (update)']], '');
  const who2 = input({ placeholder: 'Search masjid by name…' });
  const results = h('div.list');
  const pickedTxt = h('div.small.muted');
  let picked = null, t;
  const masjidBox = h('div', { hidden: true }, field('Masjid', who2), results, pickedTxt);
  linkType.onchange = () => { masjidBox.hidden = linkType.value !== 'masjid'; };
  who2.oninput = () => {
    clearTimeout(t);
    t = setTimeout(async () => {
      const qq = who2.value.trim().toLowerCase();
      clearEl(results);
      if (qq.length < 2) return;
      const s = await getDocs(query(collection(db, 'masjids'), where('status', '==', 'approved'), orderBy('nameLower'),
        where('nameLower', '>=', qq), where('nameLower', '<=', `${qq}\uf8ff`), limit(6)));
      results.append(s.docs.map((d) => h('div.list-item', { style: { cursor: 'pointer' }, onclick: () => {
        picked = { id: d.id, name: d.data().name }; clearEl(results); who2.value = d.data().name;
        pickedTxt.textContent = `Opens: ${d.data().name}`;
      } }, h('span.dot'), h('div.grow', h('b', d.data().name), h('div.muted.small', `${d.data().thana || ''}, ${d.data().district || ''}`)))));
    }, 300);
  };
  return !!await dialog({
    title: `Message ${who}`,
    wide: true,
    body: h('div',
      h('p.muted.small', 'They get a notification on their phone, and the message stays on their Notifications page. Tapping it there opens the link.'),
      field('Title', title), field('Message', body, 'Up to 500 characters. Bangla works.'),
      field('Link', linkType), masjidBox),
    actions: [
      { label: 'Cancel', value: false },
      { label: 'Send', kind: 'primary', run: async () => {
        if (!title.value.trim() || !body.value.trim()) { toast('Write a title and a message.', 'bad'); return false; }
        if (linkType.value === 'masjid' && !picked) { toast('Pick the masjid.', 'bad'); return false; }
        const link = linkType.value ? { type: linkType.value, id: picked?.id || '' } : null;
        const target = uids.length === 1 ? { type: 'user', id: uids[0] } : { type: 'users', ids: uids };
        const res = await act(null, () => queueJob('push', { target, title: title.value.trim(), body: body.value.trim(), link }));
        if (!res) return false;
        toast(res.started ? 'Sending now – see Notifications for the result.' : 'Queued – goes with the next job run (add a GitHub token in App settings to send instantly).');
        return true;
      } },
    ],
  });
}

export async function render(el, uid) {
  const snap = await getDoc(doc(db, 'users', uid));
  if (!snap.exists()) {
    el.append(pageHead('User not found'), card(null, empty('No profile – the account may have been deleted.')));
    return;
  }
  const u = snap.data();
  const reload = () => { clear(el); render(el, uid); };
  const isMe = uid === me.uid;
  const role = u.role || 'user';
  const staff = ['admin', 'superAdmin'].includes(role);
  // Admins manage ordinary users; super admins manage everyone.
  const canManage = isSuper() || !staff;

  el.append(pageHead(u.name || '(no name)', u.email || '',
    h('button.btn', { onclick: () => history.back() }, icon('back', 18), 'Back')));

  const left = h('div'), right = h('div');
  el.append(h('div.grid.g2', left, right));

  // ---- profile
  left.append(card('Profile', h('dl.kv',
    h('dt', 'Name'), h('dd', u.name || '–'),
    h('dt', 'Email'), h('dd', u.email || '–'),
    h('dt', 'Phone'), h('dd', u.phone || '–'),
    h('dt', 'Role'), h('dd', badge(roleName(role).toLowerCase(), ROLE_KIND[role])),
    h('dt', 'Sign-in'), h('dd', u.disabled ? badge('disabled', 'bad') : badge('active', 'ok')),
    h('dt', 'Volunteering'), h('dd', u.editBlocked ? badge('blocked', 'warn') : badge('allowed', 'ok')),
    h('dt', 'Joined'), h('dd', fmtDate(u.createdAt)),
    h('dt', 'Last opened'), h('dd', u.lastSeenAt ? `${fmtDate(u.lastSeenAt)} · ${u.platform || ''} ${u.appVersion || ''}` : 'not recorded (app older than 1.20)'),
    h('dt', 'Notifications'), h('dd', `${(u.fcmTokens || []).length} phone(s) registered`),
    h('dt', 'Follows'), h('dd', `${num(Object.keys(u.follows || {}).length)} masjids`),
    h('dt', 'User id'), h('dd', h('code', uid)))));

  const set = async (btn, data, action, msg) => {
    await act(btn, async () => { await updateDoc(snap.ref, data); await logAction(action, `users/${uid}`, { email: u.email, ...data }); }, msg);
    reload();
  };
  // ---- role (super admins only)
  if (isSuper() && !isMe) {
    const pick = select(ROLES, role);
    const help = h('div.f-hint', ROLE_HELP[role]);
    pick.onchange = () => { help.textContent = ROLE_HELP[pick.value]; };
    left.append(card('Role',
      field('What they can do', pick), help,
      h('div.row.end', { style: { marginTop: '10px' } }, h('button.btn.btn-primary', { onclick: async (e) => {
        if (pick.value === role) return;
        if (!await confirmDialog(`Make ${roleName(pick.value).toLowerCase()}?`, `${u.email}: ${ROLE_HELP[pick.value]}`,
          { ok: 'Change role', danger: ['admin', 'superAdmin'].includes(pick.value) })) return;
        set(e.currentTarget, { role: pick.value }, 'user.role', 'Role changed.');
      } }, 'Save role'))));
  }

  // ---- actions
  const b = (label, kind, fn) => h(`button.btn${kind ? `.btn-${kind}` : ''}`, { onclick: (e) => fn(e.currentTarget) }, label);
  if (canManage) {
    left.append(card('Manage',
      h('p.muted.small', isSuper()
        ? 'Blocking volunteering stops them editing masjid times. Disabling sign-in locks them out of the app (within an hour on phones already signed in). Deleting removes the account and profile for good.'
        : 'Blocking volunteering stops them editing masjid times. Only a super admin can disable or delete accounts.'),
      h('div.row',
        b(u.editBlocked ? 'Allow volunteering' : 'Block volunteering', '', (btn) =>
          set(btn, { editBlocked: !u.editBlocked }, u.editBlocked ? 'user.unblock' : 'user.block', 'Saved.')),
        isMe || !isSuper() ? null : b(u.disabled ? 'Enable sign-in' : 'Disable sign-in', u.disabled ? 'ok' : '', async (btn) => {
          if (!u.disabled && !await confirmDialog('Disable sign-in?', `${u.email} will be signed out and can't sign in until you enable it again.`, { danger: true, ok: 'Disable' })) return;
          await act(btn, async () => {
            const { started } = await queueJob(u.disabled ? 'enableUser' : 'disableUser', { uid, email: u.email });
            toast(started ? 'Working on it – refresh in a minute.' : 'Queued – runs with the next job (add a GitHub token in Settings to run instantly).');
          });
        }),
        isMe || !isSuper() ? null : b('Delete account', 'danger', async (btn) => {
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
  }

  // ---- direct message
  left.append(card('Send a message',
    (u.fcmTokens || []).length ? null : h('div.msg.warn', 'No phone registered for notifications – the message still waits on their Notifications page.'),
    h('p.muted.small', 'A notification on their phone that also stays on their Notifications page, with an optional link to a masjid or About the App.'),
    h('div.row.end', h('button.btn.btn-primary', { onclick: () => messageDialog([uid], u.name || u.email) }, icon('send', 16), 'Write message'))));

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
