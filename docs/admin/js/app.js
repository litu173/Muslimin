// Admin website: sign-in gate (admins and super admins), sidebar and router.
import {
  auth, db, emu, me, isSuper, onAuthStateChanged, signInWithEmailAndPassword, signInWithGoogle,
  signOut, sendPasswordResetEmail, doc, getDoc, collection, query, where,
  getCountFromServer,
} from './fb.js';
import { h, icon, clear, toast, friendlyError, input, spinner } from './ui.js';
import { loadPlaces } from './data.js';

const root = document.getElementById('root');

const NAV = [
  ['dashboard', 'Dashboard', 'dashboard'],
  ['masjids', 'Masjids', 'masjid'],
  ['review', 'Review', 'review', 'pending'],
  ['users', 'Users', 'users'],
  ['content', 'Content', 'book'],
  ['locations', 'Locations', 'map'],
  ['activity', 'Activity', 'activity'],
  ['notify', 'Notifications', 'bell'],
  ['settings', 'App settings', 'settings'],
  ['log', 'Admin log', 'log'],
];

const VIEWS = {
  dashboard: () => import('./views/dashboard.js'),
  masjids: () => import('./views/masjids.js'),
  masjid: () => import('./views/masjid.js'),
  review: () => import('./views/review.js'),
  users: () => import('./views/users.js'),
  user: () => import('./views/user.js'),
  locations: () => import('./views/locations.js'),
  content: () => import('./views/content.js'),
  activity: () => import('./views/activity.js'),
  notify: () => import('./views/notify.js'),
  settings: () => import('./views/settings.js'),
  log: () => import('./views/log.js'),
};

// ---------------------------------------------------------------- sign in
function loginScreen(message) {
  const email = input({ type: 'email', placeholder: 'Email', autocomplete: 'username' });
  const pass = input({ type: 'password', placeholder: 'Password', autocomplete: 'current-password' });
  const err = h('div.msg.bad', { hidden: !message }, message || '');
  const show = (e) => { err.hidden = false; err.textContent = friendlyAuth(e); };
  const submit = async (e) => {
    e?.preventDefault();
    try { await signInWithEmailAndPassword(auth, email.value.trim(), pass.value); } catch (x) { show(x); }
  };
  clear(root).append(h('div.login', h('form.login-card', { onsubmit: submit },
    h('div.brand', h('img', { src: '../assets/logo.svg', alt: 'Muslimin' }), h('small', 'Admin panel')),
    h('p', 'For Muslimin admins'),
    err,
    h('div.field', email), h('div.field', pass),
    h('button.btn.btn-primary', { type: 'submit' }, 'Sign in'),
    h('div.or', 'or'),
    h('button.btn', { type: 'button', onclick: async () => { try { await signInWithGoogle(); } catch (x) { show(x); } } }, 'Continue with Google'),
    h('div.or', h('a', { href: '#', onclick: async (e) => {
      e.preventDefault();
      if (!email.value.trim()) { show({ message: 'Type your email first.' }); return; }
      try { await sendPasswordResetEmail(auth, email.value.trim()); toast('Password reset email sent.'); } catch (x) { show(x); }
    } }, 'Forgot password?')),
    emu ? h('div.or', 'Emulator mode – local test data') : null)));
}

function friendlyAuth(e) {
  const c = `${e?.code || ''}`;
  if (c.includes('invalid-credential') || c.includes('wrong-password') || c.includes('user-not-found')) return 'Wrong email or password.';
  if (c.includes('unauthorized-domain')) return 'This website is not an authorised domain – add it in Firebase Authentication → Settings → Authorised domains.';
  if (c.includes('popup-closed')) return 'Sign-in window closed.';
  if (c.includes('too-many-requests')) return 'Too many tries – wait a moment.';
  return e?.message || `${e}`;
}

// ---------------------------------------------------------------- shell
let content, navEl, sideEl;
const counts = {};

function shell() {
  navEl = h('nav.nav');
  content = h('main.main');
  const initials = (me.name || me.email || '?').trim().slice(0, 1).toUpperCase();
  sideEl = h('aside.side',
    h('div.brand', h('div', h('img', { src: '../assets/logo.svg', alt: 'Muslimin' }), h('small', isSuper() ? 'Super admin' : 'Admin panel'))),
    navEl,
    themePicker(),
    h('div.me', h('div.av', initials), h('div', h('b', me.name || 'Admin'), h('span', me.email)),
      h('button', { title: 'Sign out', onclick: () => signOut(auth) }, icon('logout'))));
  clear(root).append(
    emu ? h('div.emu', 'EMULATOR – local test data, nothing here touches the live app') : null,
    h('div.shell', sideEl, content));
  document.addEventListener('click', (e) => {
    if (sideEl.classList.contains('open') && !sideEl.contains(e.target) && !e.target.closest('.burger')) sideEl.classList.remove('open');
  });
  renderNav();
  refreshCounts();
}

// Light / dark / follow the computer – remembered in this browser.
const THEME_KEY = 'muslimin-admin-theme';
function themePicker() {
  const box = h('div.theme');
  const cur = () => { try { return localStorage.getItem(THEME_KEY) || 'light'; } catch { return 'light'; } };
  const draw = () => clear(box).append([['light', 'Light'], ['dark', 'Dark'], ['system', 'System']].map(([v, label]) =>
    h(`button${cur() === v ? '.on' : ''}`, { type: 'button', onclick: () => {
      try { localStorage.setItem(THEME_KEY, v); } catch { /* private mode */ }
      if (v === 'system') delete document.documentElement.dataset.theme; else document.documentElement.dataset.theme = v;
      draw();
    } }, label)));
  draw();
  return box;
}

function renderNav() {
  const cur = (location.hash.slice(2).split('/')[0]) || 'dashboard';
  const active = cur === 'masjid' ? 'masjids' : cur === 'user' ? 'users' : cur;
  clear(navEl).append(
    NAV.map(([id, label, ic, countKey]) => h(`a${id === active ? '.on' : ''}`, { href: `#/${id}` },
      icon(ic), label, countKey && counts[countKey] ? h('span.n', counts[countKey]) : null)),
    h('div.nav-sec', 'Links'),
    h('a', { href: '../', target: '_blank' }, icon('open'), 'Website'),
    h('a', { href: 'https://console.firebase.google.com/project/muslimin-app-bd/overview', target: '_blank' }, icon('open'), 'Firebase console'));
}

export async function refreshCounts() {
  try {
    const n = async (q) => (await getCountFromServer(q)).data().count;
    const [pm, rp, sg] = await Promise.all([
      n(query(collection(db, 'masjids'), where('status', '==', 'pending'))),
      n(query(collection(db, 'reports'), where('status', '==', 'open'))),
      n(query(collection(db, 'suggestions'), where('status', '==', 'open'))),
    ]);
    counts.pending = pm + rp + sg;
    renderNav();
  } catch (e) { console.warn(e); }
}

/** Page header with a menu button on phones. */
export function pageHead(title, sub, ...actions) {
  return h('div.top',
    h('button.icon-btn.burger', { onclick: () => sideEl.classList.toggle('open'), title: 'Menu' }, icon('menu', 24)),
    h('div', h('h1', title), sub ? h('div.sub', sub) : null),
    h('div.grow'),
    ...actions);
}

let seq = 0;
async function route() {
  if (!content) return;
  renderNav();
  sideEl.classList.remove('open');
  const [name = 'dashboard', ...args] = location.hash.slice(2).split('/').map(decodeURIComponent);
  const load = VIEWS[name] || VIEWS.dashboard;
  const mine = ++seq;
  clear(content).append(spinner());
  try {
    const mod = await load();
    if (mine !== seq) return;
    clear(content);
    await mod.render(content, ...args);
  } catch (e) {
    console.error(e);
    if (mine === seq) clear(content).append(h('div.card', h('h2', 'Something went wrong'), h('p.muted', friendlyError(e))));
  }
  window.scrollTo(0, 0);
}
window.addEventListener('hashchange', route);

// ---------------------------------------------------------------- start
onAuthStateChanged(auth, async (u) => {
  if (!u) { content = null; loginScreen(); return; }
  clear(root).append(h('div.boot', h('div.spinner')));
  try {
    const p = await getDoc(doc(db, 'users', u.uid));
    const role = p.data()?.role;
    if (!['admin', 'superAdmin'].includes(role)) {
      await signOut(auth);
      loginScreen(`${u.email} is not an admin.`);
      return;
    }
    Object.assign(me, { uid: u.uid, email: u.email || '', name: p.data()?.name || u.displayName || '', role });
    await loadPlaces();
    shell();
    if (!location.hash) location.hash = '#/dashboard';
    route();
  } catch (e) {
    await signOut(auth);
    loginScreen(friendlyError(e));
  }
});
