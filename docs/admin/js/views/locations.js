// Locations: masjids per country / district / thana (where jamat times are
// still missing), and managing places – Bangla names (by hand, CSV or
// suggested), countries, and renaming a place across its masjids.
import {
  db, collection, query, where, getCountFromServer, getDocs, writeBatch, doc, limit, logAction,
} from '../fb.js';
import {
  h, icon, card, select, act, go, clear, num, spinner, table, tabs, input, field, toast,
  confirmDialog, empty,
} from '../ui.js';
import { pageHead } from '../app.js';
import {
  bdThanas, COUNTRIES, places, savePlaces, toCsv, parseCsv, download, pickFile,
} from '../data.js';
import { suggestBangla } from '../ai.js';

const n = async (q) => { try { return (await getCountFromServer(q)).data().count; } catch { return 0; } };
const approved = () => query(collection(db, 'masjids'), where('status', '==', 'approved'));

let tab = 'overview';

export async function render(el) {
  el.append(pageHead('Locations', 'Where masjids are, and the names of places'));
  const body = h('div');
  const draw = () => {
    clear(body);
    clear(tabsBox).append(tabs([['overview', 'Overview'], ['names', 'Bangla names'], ['countries', 'Countries'], ['rename', 'Rename a place']], tab,
      (t) => { tab = t; draw(); }));
    ({ overview, names, countries, rename })[tab](body);
  };
  const tabsBox = h('div');
  el.append(tabsBox, body);
  draw();
}

async function overview(el) {
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

// ---------------------------------------------------------------- names
/** Every place the app shows: BD districts and thanas, countries. */
async function allPlaces() {
  const thanas = await bdThanas();
  const rows = [];
  for (const [c, name] of COUNTRIES) rows.push({ en: name, group: 'Countries', code: c });
  for (const d of Object.keys(thanas).sort()) {
    rows.push({ en: d, group: 'Districts' });
    for (const t of thanas[d]) rows.push({ en: t, group: `Thanas – ${d}` });
  }
  for (const en of Object.keys(places.bn)) {
    if (!rows.some((r) => r.en === en)) rows.push({ en, group: 'Other (cities, areas abroad)' });
  }
  return rows;
}

async function names(el) {
  const rows = await allPlaces();
  const groups = [...new Set(rows.map((r) => r.group))];
  const draft = { ...places.bn };
  const grp = select([['', 'All places'], ['missing', 'Missing a Bangla name'], ...groups.map((g) => [g, g])], 'missing');
  const q = input({ placeholder: 'Search…' });
  const out = h('div');
  const dirty = h('span.muted.small');
  const countDirty = () => {
    const n = Object.keys({ ...draft, ...places.bn }).filter((k) => (draft[k] || '') !== (places.bn[k] || '')).length;
    dirty.textContent = n ? `${num(n)} unsaved change${n > 1 ? 's' : ''}` : '';
  };
  const shown = () => {
    const t = q.value.trim().toLowerCase();
    return rows.filter((r) => (!grp.value || (grp.value === 'missing' ? !draft[r.en] : r.group === grp.value))
      && (!t || r.en.toLowerCase().includes(t) || (draft[r.en] || '').includes(t)));
  };
  const drawRows = () => {
    const list = shown();
    clear(out).append(
      h('div.muted.small', { style: { margin: '6px 0 10px' } }, `${num(list.length)} places${list.length > 300 ? ' – showing the first 300, search to narrow' : ''}`),
      table([
        { label: 'English (as in the app)', cell: (r) => h('div.t-name', h('b', r.en), h('span', r.group)) },
        { label: 'Bangla', cell: (r) => {
          const i = input({ value: draft[r.en] || '', placeholder: '—' });
          i.oninput = () => { const v = i.value.trim(); if (v) draft[r.en] = v; else delete draft[r.en]; countDirty(); };
          return i;
        } },
      ], list.slice(0, 300), { emptyText: 'Nothing here – every place has a Bangla name.' }));
  };
  grp.onchange = drawRows;
  let timer;
  q.oninput = () => { clearTimeout(timer); timer = setTimeout(drawRows, 250); };

  const save = h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
    await savePlaces({ bn: { ...draft } });
    await logAction('places.names', 'config/places', { count: Object.keys(draft).length });
    countDirty();
  }, 'Saved – the app shows these names in Bangla.') }, 'Save names');

  el.append(card(h('div.row', h('h2', 'Bangla names of places'), h('div.grow'), dirty),
    h('p.muted.small', 'The app shows district, thana, city and country names in Bangla when the phone is in Bangla. Leave one empty to show the English name. Masjid names in Bangla are edited on each masjid (or in bulk under Masjids → Bangla names).'),
    h('div.filters', h('div.search', icon('search'), q), grp),
    h('div.row', { style: { marginBottom: '10px' } },
      h('button.btn.btn-sm', { onclick: (e) => act(e.currentTarget, async () => {
        const todo = shown().filter((r) => !draft[r.en]).map((r) => r.en).slice(0, 300);
        if (!todo.length) { toast('Every place shown already has a Bangla name.'); return; }
        const got = await suggestBangla(todo, 'place');
        Object.assign(draft, got);
        drawRows(); countDirty();
        toast(`${num(Object.keys(got).length)} suggestions filled in – check them, then Save.`);
      }) }, '✨ Suggest Bangla for the empty ones shown'),
      h('button.btn.btn-sm', { onclick: () => download('muslimin-place-names.csv', toCsv(['english', 'bangla', 'group'], rows.map((r) => [r.en, draft[r.en] || '', r.group]))) }, 'Export CSV'),
      h('button.btn.btn-sm', { onclick: async () => {
        const text = await pickFile();
        if (!text) return;
        const list = parseCsv(text).filter((r) => r.english);
        if (!list.length || !('bangla' in list[0])) { toast('The file needs the columns english,bangla', 'bad'); return; }
        let n = 0;
        for (const r of list) { if (r.bangla) { draft[r.english] = r.bangla; n++; } }
        drawRows(); countDirty();
        toast(`${num(n)} names loaded from the file – check them, then Save.`);
      } }, 'Import CSV')),
    h('pre.csv', 'english,bangla\nDhaka,ঢাকা\nMirpur,মিরপুর'),
    out,
    h('div.row.end', { style: { marginTop: '12px' } }, save)));
  drawRows();
}

// ---------------------------------------------------------------- countries
function countries(el) {
  const out = h('div');
  const draw = () => clear(out).append(table([
    { label: 'Code', cell: ([c]) => h('code', c) },
    { label: 'Name', cell: ([, n]) => h('b', n) },
    { label: 'Bangla', cell: ([, n]) => places.bn[n] || h('span.muted', '–') },
    { label: 'Added by', cell: ([c]) => (places.countries[c] ? 'an admin' : h('span.muted', 'built in')) },
    { label: '', class: 'r', cell: ([c, n]) => (places.countries[c] ? h('button.icon-btn', { title: 'Remove', onclick: async () => {
      if (!await confirmDialog(`Remove ${n}?`, 'Masjids already in this country keep it; it just leaves the list.', { danger: true, ok: 'Remove' })) return;
      const next = { ...places.countries }; delete next[c];
      await act(null, () => savePlaces({ countries: next }), 'Removed.');
      const i = COUNTRIES.findIndex(([k]) => k === c); if (i >= 0) COUNTRIES.splice(i, 1);
      draw();
    } }, icon('trash', 18)) : null) },
  ], [...COUNTRIES].sort((a, b) => a[1].localeCompare(b[1]))));
  const code = input({ placeholder: 'e.g. EG', maxLength: 2 });
  const name = input({ placeholder: 'e.g. Egypt' });
  const bn = input({ placeholder: 'e.g. মিশর' });
  const add = async (list) => {
    const next = { ...places.countries };
    const bnNext = { ...places.bn };
    for (const r of list) {
      const c = r.code.toUpperCase();
      if (!/^[A-Z]{2}$/.test(c) || !r.name) continue;
      next[c] = r.name;
      if (r.bangla) bnNext[r.name] = r.bangla;
      const i = COUNTRIES.findIndex(([k]) => k === c);
      if (i >= 0) COUNTRIES[i] = [c, r.name]; else COUNTRIES.push([c, r.name]);
    }
    await savePlaces({ countries: next, bn: bnNext });
    await logAction('places.countries', 'config/places', { count: list.length });
    draw();
  };
  el.append(h('div.grid.g2',
    card('Add or rename a country',
      h('p.muted.small', 'Countries appear in the masjid forms and filters here. Use the two-letter ISO code (the same the app detects from the phone\'s location). Saving an existing code renames it.'),
      h('div.grid.g3', field('Code', code), field('Name (English)', name), field('Name (Bangla)', bn)),
      h('div.row.end', h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
        if (!/^[A-Za-z]{2}$/.test(code.value.trim()) || !name.value.trim()) throw new Error('Type a 2-letter code and a name.');
        await add([{ code: code.value.trim(), name: name.value.trim(), bangla: bn.value.trim() }]);
        code.value = ''; name.value = ''; bn.value = '';
      }, 'Saved.') }, 'Save country'))),
    card('Upload many countries (CSV)',
      h('p.muted.small', 'A spreadsheet saved as CSV with the columns code,name,bangla (bangla optional).'),
      h('pre.csv', 'code,name,bangla\nEG,Egypt,মিশর\nJO,Jordan,জর্ডান'),
      h('div.row.end',
        h('button.btn', { onclick: () => download('muslimin-countries.csv', toCsv(['code', 'name', 'bangla'], COUNTRIES.map(([c, n]) => [c, n, places.bn[n] || '']))) }, 'Export CSV'),
        h('button.btn.btn-primary', { onclick: async (e) => {
          const text = await pickFile();
          if (!text) return;
          const list = parseCsv(text).filter((r) => r.code && r.name);
          if (!list.length) { toast('No rows with code and name found.', 'bad'); return; }
          if (!await confirmDialog(`Save ${list.length} countries?`, list.slice(0, 8).map((r) => `${r.code} ${r.name}`).join(', ') + (list.length > 8 ? '…' : ''), { ok: 'Save' })) return;
          await act(e.currentTarget, () => add(list), `${list.length} countries saved.`);
        } }, 'Upload CSV')))),
  card('Countries', out));
  draw();
}

// ---------------------------------------------------------------- rename
async function rename(el) {
  const thanas = await bdThanas();
  const kind = select([['thana', 'Thana / area'], ['district', 'District / city']], 'thana');
  const country = select(COUNTRIES, 'BD');
  const district = input({ placeholder: 'District / city it is in (for a thana)' });
  const from = input({ placeholder: 'Name now (exactly as on the masjids)' });
  const to = input({ placeholder: 'New name' });
  const list = h('datalist', { id: 'place-list' }, Object.keys(thanas).flatMap((d) => [d, ...thanas[d]]).map((n) => h('option', { value: n })));
  [district, from].forEach((i) => i.setAttribute('list', 'place-list'));
  const sync = () => { district.parentElement.hidden = kind.value !== 'thana'; };
  kind.onchange = sync;
  const out = h('div');
  const find = () => {
    const c = [where(kind.value, '==', from.value.trim())];
    if (kind.value === 'thana' && district.value.trim()) c.push(where('district', '==', district.value.trim()));
    if (country.value !== 'BD') c.push(where('country', '==', country.value));
    return query(collection(db, 'masjids'), ...c, limit(2000));
  };
  el.append(card('Rename a place on every masjid',
    h('p.muted.small', 'Fixes a misspelt or changed place name: every masjid with the old name gets the new one, and its Bangla name moves along. Bangladesh thanas used by the app\'s area list come from the map data, so rename those only to match it.'),
    list,
    h('div.grid.g2', field('What', kind), field('Country', country)),
    field('In district / city', district),
    h('div.grid.g2', field('Old name', from), field('New name', to)),
    h('div.row.end',
      h('button.btn', { onclick: (e) => act(e.currentTarget, async () => {
        if (!from.value.trim()) throw new Error('Type the old name.');
        const s = await getDocs(find());
        clear(out).append(s.empty ? empty('No masjids have this name.') : h('div.msg', `${num(s.size)} masjids have it, e.g. ${s.docs.slice(0, 5).map((d) => d.data().name).join(', ')}.`));
      }) }, 'Check'),
      h('button.btn.btn-primary', { onclick: (e) => act(e.currentTarget, async () => {
        const a = from.value.trim(), b = to.value.trim();
        if (!a || !b || a === b) throw new Error('Type the old and the new name.');
        const s = await getDocs(find());
        if (!await confirmDialog(`Rename on ${num(s.size)} masjids?`, `${a} → ${b}`, { ok: 'Rename' })) return;
        for (let i = 0; i < s.docs.length; i += 400) {
          const batch = writeBatch(db);
          for (const d of s.docs.slice(i, i + 400)) batch.update(doc(db, 'masjids', d.id), { [kind.value]: b });
          await batch.commit();
        }
        if (places.bn[a] && !places.bn[b]) {
          const bn = { ...places.bn, [b]: places.bn[a] };
          await savePlaces({ bn });
        }
        await logAction('places.rename', 'masjids', { kind: kind.value, from: a, to: b, count: s.size });
        clear(out).append(h('div.msg', `Renamed on ${num(s.size)} masjids.`));
      }) }, 'Rename')),
    out));
  sync();
}
