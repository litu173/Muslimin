// App settings: switches the app reads at start (config/app), the GitHub
// token for instant jobs (kept only in this browser) and the admin team.
import {
  db, doc, getDoc, setDoc, collection, query, where, getDocs, serverTimestamp, logAction,
} from '../fb.js';
import { h, card, input, field, act, link, badge, toast, empty } from '../ui.js';
import { pageHead } from '../app.js';
import { ghToken, startJobs } from '../data.js';

export async function render(el) {
  el.append(pageHead('App settings', 'Switches every phone reads when the app starts'));
  const ref = doc(db, 'config', 'app');
  const c = (await getDoc(ref)).data() || {};

  const grid = h('div.grid.g2');
  el.append(grid);

  // ---- versions
  const minV = input({ value: c.minVersion || '', placeholder: 'e.g. 1.18.5' });
  const latest = input({ value: c.latestVersion || '', placeholder: 'e.g. 1.18.5' });
  grid.append(card('App version',
    field('Minimum version', minV, 'Phones with an older version are asked to update before they can continue. Leave empty for no forced update.'),
    field('Latest version (info)', latest, 'Shown to users as the newest version.'),
    h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
      const ok = (v) => !v || /^\d+\.\d+\.\d+$/.test(v);
      if (!ok(minV.value.trim()) || !ok(latest.value.trim())) throw new Error('Versions look like 1.18.5');
      await setDoc(ref, { minVersion: minV.value.trim(), latestVersion: latest.value.trim(), updatedAt: serverTimestamp() }, { merge: true });
      await logAction('config.version', 'config/app', { minVersion: minV.value.trim() });
    }, 'Saved.') }, 'Save'))));

  // ---- maintenance banner
  const m = c.maintenance || {};
  const on = h('input', { type: 'checkbox', checked: !!m.on });
  const en = h('textarea.inp', { value: m.messageEn || '', placeholder: 'We are updating Muslimin – some data may be missing for an hour.' });
  const bn = h('textarea.inp', { value: m.messageBn || '', placeholder: 'মুসলিমিন হালনাগাদ চলছে – এক ঘণ্টা কিছু তথ্য না-ও দেখা যেতে পারে।' });
  grid.append(card('Banner in the app',
    h('label.switch', { style: { marginBottom: '12px' } }, on, 'Show a banner at the top of Home'),
    field('Message (English)', en), field('Message (Bangla)', bn),
    h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
      await setDoc(ref, { maintenance: { on: on.checked, messageEn: en.value.trim(), messageBn: bn.value.trim() }, updatedAt: serverTimestamp() }, { merge: true });
      await logAction('config.banner', 'config/app', { on: on.checked });
    }, 'Saved.') }, 'Save'))));

  // ---- GitHub token
  const tok = input({ type: 'password', value: ghToken.get(), placeholder: 'github_pat_…' });
  grid.append(card('Send instantly (GitHub token)',
    h('p.small', 'On the free Firebase plan, notifications and account actions are run by a GitHub job. With a token saved here, this website starts that job immediately; without one, it runs on its schedule (every 15 min, sometimes later).'),
    h('ol.small', h('li', 'GitHub → Settings → Developer settings → Fine-grained tokens → Generate new token.'),
      h('li', 'Repository access: only litu173/Muslimin. Permissions: Actions → Read and write.'),
      h('li', 'Paste it below. It is stored only in this browser on this computer.')),
    field('Token', tok),
    h('div.row.end',
      h('button.btn', { onclick: () => { ghToken.set(''); tok.value = ''; toast('Token removed from this browser.'); } }, 'Remove'),
      h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
        ghToken.set(tok.value.trim());
        toast((await startJobs()) ? 'Token works – job started.' : 'Saved, but GitHub refused it – check the permissions.', 'ok');
      }) }, 'Save & test'))));

  // ---- admin team
  const admins = await getDocs(query(collection(db, 'users'), where('role', '==', 'superAdmin')));
  grid.append(card('Super admins', admins.empty ? empty('None.') : h('div.list', admins.docs.map((d) => h('div.list-item', h('span.dot'),
    h('div.grow', link(`/user/${d.id}`, d.data().name || d.data().email), h('div.muted.small', d.data().email)), badge('super admin', 'gold')))),
  h('p.muted.small', { style: { marginTop: '10px' } }, 'To add an admin, open their profile under Users and choose “Make super admin”.')));
}
