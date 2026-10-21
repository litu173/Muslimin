// Locations: masjids per country, and per district / thana in Bangladesh –
// how many there are and how many have jamat times (where help is needed).
import { db, collection, query, where, getCountFromServer } from '../fb.js';
import { h, card, select, act, go, clear, num, spinner, table } from '../ui.js';
import { pageHead } from '../app.js';
import { bdThanas, COUNTRIES } from '../data.js';

const n = async (q) => { try { return (await getCountFromServer(q)).data().count; } catch { return 0; } };
const approved = () => query(collection(db, 'masjids'), where('status', '==', 'approved'));

export async function render(el) {
  el.append(pageHead('Locations', 'Where masjids are – and where jamat times are still missing'));
  const thanas = await bdThanas();
  const districts = Object.keys(thanas).sort();

  // ---- countries
  const countriesBox = h('div', spinner());
  el.append(card('By country', countriesBox));
  (async () => {
    const all = await n(approved());
    const abroad = await Promise.all(COUNTRIES.filter(([c]) => c !== 'BD')
      .map(async ([c, name]) => [c, name, await n(query(approved(), where('country', '==', c)))]));
    const others = abroad.filter(([, , k]) => k > 0);
    const bd = all - others.reduce((a, [, , k]) => a + k, 0);
    clear(countriesBox).append(bars([['BD', 'Bangladesh', bd], ...others], all, ([c]) => go(`#/masjids///${c}`)),
      h('p.muted.small', others.length ? '' : 'Only Bangladesh so far. Masjids in other countries appear here once added.'));
  })();

  // ---- districts (on demand – about 130 small counts)
  const distBox = h('div');
  el.append(card(h('div.row', h('h2', 'Bangladesh – districts'), h('div.grow'),
    h('button.btn.btn-sm', { onclick: (e) => act(e.currentTarget, () => loadDistricts()) }, 'Count all 64 districts')),
  h('p.muted.small', 'Counting every district reads about 130 small counts from the database; run it when you need the overview.'),
  distBox));

  async function loadDistricts() {
    clear(distBox).append(spinner());
    const rows = await Promise.all(districts.map(async (d) => {
      const q = query(approved(), where('district', '==', d));
      const [total, times] = await Promise.all([n(q), n(query(q, where('hasJamat', '==', true)))]);
      return { d, total, times };
    }));
    rows.sort((a, b) => b.total - a.total);
    clear(distBox).append(table([
      { label: 'District', cell: (r) => h('b', r.d) },
      { label: 'Masjids', class: 'r', cell: (r) => num(r.total) },
      { label: 'With times', class: 'r', cell: (r) => num(r.times) },
      { label: 'Coverage', cell: (r) => coverage(r.times, r.total) },
    ], rows, { onRow: (r) => { pick.value = r.d; loadThanas(); window.scrollTo({ top: thanaCard.offsetTop - 20, behavior: 'smooth' }); } }));
  }

  // ---- thanas of one district
  const pick = select(districts.map((d) => [d, d]), 'Dhaka');
  const thanaBox = h('div');
  const thanaCard = card(h('div.row', h('h2', 'Thanas of'), pick), thanaBox);
  el.append(thanaCard);
  pick.onchange = () => loadThanas();

  async function loadThanas() {
    clear(thanaBox).append(spinner());
    const d = pick.value;
    const rows = await Promise.all((thanas[d] || []).map(async (t) => {
      const q = query(approved(), where('district', '==', d), where('thana', '==', t));
      const [total, times] = await Promise.all([n(q), n(query(q, where('hasJamat', '==', true)))]);
      return { t, total, times };
    }));
    rows.sort((a, b) => b.total - a.total);
    clear(thanaBox).append(table([
      { label: 'Thana', cell: (r) => h('b', r.t) },
      { label: 'Masjids', class: 'r', cell: (r) => num(r.total) },
      { label: 'With times', class: 'r', cell: (r) => num(r.times) },
      { label: 'Coverage', cell: (r) => coverage(r.times, r.total) },
    ], rows, { onRow: (r) => go(`#/masjids/${encodeURIComponent(d)}/${encodeURIComponent(r.t)}`) }),
    h('p.muted.small', 'Click a thana to see its masjids. A thana with 0 masjids may mean masjids there were filed under a neighbouring thana.'));
  }
  loadThanas();
}

function coverage(times, total) {
  const p = total ? Math.round((times / total) * 100) : 0;
  return h('div.row', { style: { flexWrap: 'nowrap' } },
    h('div.bar', { style: { width: '120px' } }, h('i', { style: { width: `${p}%` } })), h('span.muted.small', `${p}%`));
}

function bars(rows, total, onPick) {
  return h('div.bars', rows.map((r) => {
    const [, name, k] = r;
    return h('div.bar-row', { style: { cursor: 'pointer' }, onclick: () => onPick(r) },
      h('span', name), h('div.bar', h('i', { style: { width: `${total ? (k / total) * 100 : 0}%` } })), h('span.n', num(k)));
  }));
}
