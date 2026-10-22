// Content: what the app shows besides masjids – the ayat on pull-to-refresh,
// the Home verses, the duas and the dhikr – viewable and correctable here.
//
// The app has the same content built in. Saving a set writes content/<set>
// and moves config/app.contentVersion.<set>; phones then download that set
// once (one read per change). "Use the app's built-in" removes the edit.
// The Quran itself comes live from quran.com and is not edited here.
import {
  db, me, doc, getDoc, setDoc, deleteDoc, serverTimestamp, logAction,
} from '../fb.js';
import {
  h, icon, card, input, field, select, dialog, act, toast, clear, spinner, empty, tabs, ago,
  confirmDialog, num,
} from '../ui.js';
import { pageHead } from '../app.js';

const SETS = [
  ['refreshAyat', 'Refresh ayat'],
  ['homeVerses', 'Home verses'],
  ['duas', 'Duas'],
  ['dhikr', 'Dhikr'],
  ['quran', 'Quran'],
];

// App languages: meaning in each (Arabic shows only the ayah).
const LANGS = [['bn', 'Bangla'], ['en', 'English'], ['hi', 'Hindi'], ['ur', 'Urdu'], ['id', 'Indonesian'],
  ['ms', 'Malay'], ['tr', 'Turkish'], ['es', 'Spanish']];
// The same quran.com translations the app's Quran tab uses.
const TRANSLATION = { en: 20, bn: 213, hi: 122, ur: 234, id: 33, ms: 39, tr: 77, es: 83 };
const QURAN = 'https://api.quran.com/api/v4';

const SCENES = {
  wake: 'Waking up', restroom: 'Restroom', wudu: 'Wudu', dress: 'Getting dressed', athan: 'The adhan',
  masjid: 'To the masjid', after_salah: 'After salah', morning: 'Morning adhkar', eating: 'Breakfast',
  leave_home: 'Stepping out', travel: 'On the way', meeting: 'Meeting people', good_news: 'When good things happen',
  hardship: 'When it gets hard', patience: 'Loss and patience', anger: 'Holding back anger', pain: 'Pain and sickness',
  rain: 'When it rains', home: 'Back home', gathering: 'Leaving a gathering', forgiveness: 'Seeking forgiveness',
  sleep: 'Before sleep', night: 'In the night',
};

let tab = 'refreshAyat';

export async function render(el) {
  el.append(pageHead('Content', 'What the app shows – view it, correct it, add to it'));
  const tabsBox = h('div'), body = h('div');
  el.append(tabsBox, body);
  const draw = () => {
    clear(tabsBox).append(tabs(SETS.map(([id, label]) => [id, label]), tab, (t) => { tab = t; draw(); }));
    clear(body).append(spinner());
    (tab === 'quran' ? quranInfo(body) : openSet(body, tab)).catch((e) => {
      console.error(e);
      clear(body).append(card(null, h('div.msg.bad', e.message || `${e}`)));
    });
  };
  draw();
}

// ---------------------------------------------------------------- storage
async function loadSet(set) {
  const snap = await getDoc(doc(db, 'content', set));
  if (snap.exists() && snap.data().data != null) {
    return { data: structuredClone(snap.data().data), edited: true, at: snap.data().updatedAt, by: snap.data().updatedByName };
  }
  const r = await fetch(`data/content/${set}.json`, { cache: 'no-store' });
  return { data: await r.json(), edited: false };
}

async function bumpVersion(set) {
  await setDoc(doc(db, 'config', 'app'), { contentVersion: { [set]: Date.now() }, updatedAt: serverTimestamp() }, { merge: true });
}

async function saveSet(set, data, note) {
  await setDoc(doc(db, 'content', set), { data, updatedAt: serverTimestamp(), updatedBy: me.uid, updatedByName: me.name || 'Admin' });
  await bumpVersion(set);
  await logAction(`content.${set}`, `content/${set}`, { note });
}

async function resetSet(set) {
  await deleteDoc(doc(db, 'content', set));
  await bumpVersion(set);
  await logAction(`content.${set}.reset`, `content/${set}`, {});
}

// ---------------------------------------------------------------- quran.com
const clean = (t) => `${t}`.replace(/<sup[^>]*>.*?<\/sup>/g, '').replace(/<[^>]+>/g, '')
  .replace(/\s*\[[0-9০-৯]+\]/g, '').replace(/\s+/g, ' ').trim();

/** "2:255" or "94:5-6" -> the verse keys. */
function verseKeys(ref) {
  const m = `${ref}`.trim().match(/^(\d{1,3}):(\d{1,3})(?:-(\d{1,3}))?$/);
  if (!m) throw new Error('Write the reference like 2:255 or 94:5-6.');
  const [s, a, b = a] = [Number(m[1]), Number(m[2]), Number(m[3] || m[2])];
  if (s < 1 || s > 114 || b < a || b - a > 9) throw new Error('That reference doesn\'t look right.');
  return Array.from({ length: b - a + 1 }, (_, i) => `${s}:${a + i}`);
}

/** Arabic (Uthmani) and every app language's meaning, from quran.com. */
async function fetchAyah(ref) {
  const ks = verseKeys(ref);
  const get = async (url) => { const r = await fetch(url); if (!r.ok) throw new Error(`quran.com: ${r.status}`); return r.json(); };
  const ar = (await Promise.all(ks.map((k) => get(`${QURAN}/quran/verses/uthmani?verse_key=${k}`))))
    .map((j) => j.verses[0].text_uthmani).join(' ۝ ');
  const tr = {};
  await Promise.all(Object.entries(TRANSLATION).map(async ([lang, id]) => {
    const parts = await Promise.all(ks.map((k) => get(`${QURAN}/quran/translations/${id}?verse_key=${k}`)));
    tr[lang] = parts.map((j) => clean(j.translations[0].text)).join(' ');
  }));
  const ch = (await get(`${QURAN}/chapters/${ks[0].split(':')[0]}`)).chapter;
  const short = ks.length > 1 ? `${ks[0]}-${ks[ks.length - 1].split(':')[1]}` : ks[0];
  return { ref: short, ar, tr, surahEn: ch.name_simple, surahAr: ch.name_arabic };
}

// ---------------------------------------------------------------- editor shell
/** Loads a set and shows its editor with Save / Reset and an unsaved marker. */
async function openSet(body, set) {
  const s = await loadSet(set);
  let dirty = false;
  const status = h('span.muted.small');
  const saveBtn = h('button.btn.btn-primary', { disabled: true }, 'Save changes');
  const markDirty = () => { dirty = true; saveBtn.disabled = false; status.textContent = 'Unsaved changes'; };
  const list = h('div');
  const editors = { refreshAyat: ayahList, homeVerses: ayahList, duas: duaEditor, dhikr: dhikrEditor };
  const redraw = () => clear(list).append(editors[set](set, s.data, () => { markDirty(); redraw(); }, redraw));
  saveBtn.onclick = (e) => act(e.currentTarget, async () => {
    if (!await confirmDialog('Save and send to the app?', 'Phones download the new version the next time the app opens (or right away if it is open).', { ok: 'Save' })) return;
    await saveSet(set, s.data, '');
    dirty = false; saveBtn.disabled = true; s.edited = true;
    status.textContent = 'Saved – phones will pick it up.';
  });
  window.onbeforeunload = () => (dirty ? true : null);
  clear(body).append(
    card(null,
      h('div.row',
        s.edited ? h('span', h('b', 'Edited by admins'), h('span.muted.small', ` – last saved ${ago(s.at)}${s.by ? ` by ${s.by}` : ''}`))
          : h('span.muted', 'Showing what is built into the app. Change anything and save to update every phone.'),
        h('div.grow'), status,
        s.edited ? h('button.btn', { onclick: (e) => act(e.currentTarget, async () => {
          if (!await confirmDialog('Go back to the built-in version?', 'Your edits to this set are removed, and phones go back to what is built into the app.', { danger: true, ok: 'Use built-in' })) return;
          await resetSet(set);
          openSet(body, set);
        }, 'Back to the built-in version.') }, 'Use the app\'s built-in') : null,
        saveBtn)),
    list);
  redraw();
}

const move = (arr, i, d) => { const j = i + d; if (j < 0 || j >= arr.length) return; [arr[i], arr[j]] = [arr[j], arr[i]]; };
const rowTools = (arr, i, changed, onEdit) => h('div.row', { style: { flexWrap: 'nowrap', gap: '2px' } },
  h('button.icon-btn', { title: 'Move up', onclick: () => { move(arr, i, -1); changed(); } }, '↑'),
  h('button.icon-btn', { title: 'Move down', onclick: () => { move(arr, i, 1); changed(); } }, '↓'),
  onEdit ? h('button.icon-btn', { title: 'Edit', onclick: onEdit }, '✎') : null,
  h('button.icon-btn', { title: 'Remove', onclick: async () => {
    if (!await confirmDialog('Remove this?', 'It is removed from the app when you save.', { danger: true, ok: 'Remove' })) return;
    arr.splice(i, 1); changed();
  } }, icon('trash', 17)));

const arabic = (text) => h('div', { dir: 'rtl', lang: 'ar', style: { fontFamily: '"Scheherazade New", "Amiri", serif', fontSize: '20px', lineHeight: 1.8 } }, text);
const ARABIC_NOTE = 'Arabic of the Quran must match a verified copy – use “Fill from quran.com” rather than typing it.';

// ---------------------------------------------------------------- ayat (refresh + Home)
function ayahList(set, items, changed) {
  const home = set === 'homeVerses';
  const add = h('button.btn.btn-primary', { onclick: () => editAyah(set, null, (v) => { items.push(v); changed(); }) }, icon('plus', 16), 'Add an ayah');
  return card(null,
    h('div.row', h('p.muted.small', { style: { margin: 0, flex: 1 } }, home
      ? 'The verses that turn on Home (one every 8 seconds), in this order.'
      : 'One of these shows each time someone pulls a page down to refresh, picked at random. Keep them short.'), add),
    items.length ? h('div.list', items.map((v, i) => h('div.list-item',
      h('b.num-tag', { style: { minWidth: '26px' } }, i + 1),
      h('div.grow',
        h('div.row', h('b', home ? (v.ref?.en || '') : v.ref), home && v.ref?.bn ? h('span.muted.small', v.ref.bn) : null),
        arabic(v.ar),
        h('div.small', v.tr?.bn || ''), h('div.small.muted', v.tr?.en || '')),
      rowTools(items, i, changed, () => editAyah(set, v, (nv) => { items[i] = nv; changed(); }))))) : empty('Nothing yet – add an ayah.'));
}

function editAyah(set, v, done) {
  const home = set === 'homeVerses';
  const cur = structuredClone(v || { ref: home ? {} : '', ar: '', tr: {} });
  const refKey = input({ placeholder: 'e.g. 2:255 or 94:5-6', value: home ? (cur.ref?.en || '').match(/\d+:\d+(-\d+)?/)?.[0] || '' : cur.ref });
  const ar = h('textarea.inp', { dir: 'rtl', value: cur.ar, style: { fontSize: '19px', minHeight: '80px' } });
  const tr = Object.fromEntries(LANGS.map(([l]) => [l, h('textarea.inp', { value: cur.tr?.[l] || '', style: { minHeight: '60px' } })]));
  const refs = home ? Object.fromEntries([['en', 'English'], ['bn', 'Bangla'], ['ar', 'Arabic'], ...LANGS.slice(2)].map(([l]) => [l, input({ value: cur.ref?.[l] || '' })])) : null;
  const fill = h('button.btn', { type: 'button', onclick: (e) => act(e.currentTarget, async () => {
    const a = await fetchAyah(refKey.value);
    ar.value = a.ar;
    for (const [l] of LANGS) tr[l].value = a.tr[l] || '';
    if (home) {
      refs.en.value = `${a.surahEn} ${a.ref}`;
      refs.ar.value = `${a.surahAr} ${a.ref}`;
      if (!refs.bn.value) refs.bn.value = a.ref.replace(/\d/g, (d) => '০১২৩৪৫৬৭৮৯'[d]);
    } else refKey.value = a.ref;
  }, 'Filled from quran.com – check, then Done.') }, 'Fill from quran.com');
  return dialog({
    title: v ? 'Edit ayah' : 'Add an ayah',
    wide: true,
    body: h('div',
      h('div.row', { style: { alignItems: 'flex-end', flexWrap: 'nowrap' } }, h('div', { style: { flex: 1 } }, field('Surah:ayah', refKey)), h('div', { style: { marginBottom: '12px' } }, fill)),
      field('Arabic', ar, ARABIC_NOTE),
      home ? h('div', h('div.f-label', 'Reference as shown (per language – empty uses English)'),
        h('div.grid.g3', { style: { gap: '8px', margin: '6px 0 12px' } }, Object.entries(refs).map(([l, i]) => field(l, i))))
        : null,
      h('div.f-label', 'Meaning (empty uses English)'),
      h('div.grid.g2', { style: { gap: '8px', marginTop: '6px' } }, LANGS.map(([l, label]) => field(label, tr[l])))),
    actions: [{ label: 'Cancel', value: null }, { label: 'Done', kind: 'primary', run: () => {
      if (!ar.value.trim()) { toast('The Arabic is empty – use Fill from quran.com.', 'bad'); return false; }
      if (!tr.en.value.trim()) { toast('Add at least the English meaning.', 'bad'); return false; }
      const out = { ar: ar.value.trim(), tr: {} };
      for (const [l] of LANGS) if (tr[l].value.trim()) out.tr[l] = tr[l].value.trim();
      if (home) {
        out.ref = {};
        for (const [l, i] of Object.entries(refs)) if (i.value.trim()) out.ref[l] = i.value.trim();
        if (!out.ref.en) { toast('Add the English reference, e.g. Al-Baqarah 2:45.', 'bad'); return false; }
      } else {
        try { verseKeys(refKey.value); } catch (e) { toast(e.message, 'bad'); return false; }
        out.ref = refKey.value.trim();
      }
      done(out);
      return true;
    } }],
  });
}

// ---------------------------------------------------------------- duas
let scene = 'wake';
function duaEditor(set, data, changed, redraw) {
  const scenes = data.scenes || [];
  const pick = select(scenes.map((s) => [s.id, `${SCENES[s.id] || s.id} (${s.duas.length})`]), scene);
  pick.onchange = () => { scene = pick.value; redraw(); };
  const sc = scenes.find((s) => s.id === scene) || scenes[0];
  if (!sc) return card(null, empty('No duas.'));
  const nextN = () => Math.max(0, ...scenes.flatMap((s) => s.duas.map((d) => d.n || 0))) + 1;
  return card(null,
    h('div.row', field('Moment of the day', pick), h('div.grow'),
      h('button.btn.btn-primary', { onclick: () => editDua(null, (d) => { sc.duas.push({ ...d, n: nextN() }); changed(); }) }, icon('plus', 16), 'Add a dua')),
    h('p.muted.small', `${num(scenes.reduce((a, s) => a + s.duas.length, 0))} duas in ${scenes.length} moments. Source: ${data.source || 'Hisn al-Muslim'}.`),
    sc.duas.length ? h('div.list', sc.duas.map((d, i) => h('div.list-item',
      h('b.num-tag', { style: { minWidth: '26px' } }, i + 1),
      h('div.grow', arabic(d.ar), h('div.small', d.bn), h('div.small.muted', d.en),
        h('div.small.muted', `${d.ref_bn || d.ref_en || ''}${d.repeat > 1 ? ` · ×${d.repeat}` : ''}`)),
      rowTools(sc.duas, i, changed, () => editDua(d, (nd) => { sc.duas[i] = { ...d, ...nd }; changed(); }))))) : empty('No duas here yet.'));
}

function editDua(d, done) {
  const cur = d || { ar: '', tr: '', en: '', bn: '', ref_bn: '', ref_en: '', repeat: 1, audio: '' };
  const f = {
    ar: h('textarea.inp', { dir: 'rtl', value: cur.ar, style: { fontSize: '19px', minHeight: '90px' } }),
    tr: h('textarea.inp', { value: cur.tr, style: { minHeight: '60px' } }),
    bn: h('textarea.inp', { value: cur.bn, style: { minHeight: '60px' } }),
    en: h('textarea.inp', { value: cur.en, style: { minHeight: '60px' } }),
    ref_bn: input({ value: cur.ref_bn }), ref_en: input({ value: cur.ref_en }),
    repeat: input({ type: 'number', min: 1, value: cur.repeat || 1 }),
    audio: input({ value: cur.audio, placeholder: 'https://… (optional)' }),
  };
  return dialog({
    title: d ? 'Edit dua' : 'Add a dua',
    wide: true,
    body: h('div',
      field('Arabic', f.ar, 'Copy it exactly from Hisn al-Muslim or another verified source.'),
      field('Pronunciation', f.tr),
      h('div.grid.g2', field('Meaning (Bangla)', f.bn), field('Meaning (English)', f.en)),
      h('div.grid.g2', field('Reference (Bangla)', f.ref_bn), field('Reference (English)', f.ref_en)),
      h('div.grid.g2', field('Times to say it', f.repeat), field('Audio link', f.audio))),
    actions: [{ label: 'Cancel', value: null }, { label: 'Done', kind: 'primary', run: () => {
      if (!f.ar.value.trim() || !f.bn.value.trim()) { toast('Arabic and the Bangla meaning are needed.', 'bad'); return false; }
      done({
        ar: f.ar.value.trim(), tr: f.tr.value.trim(), bn: f.bn.value.trim(), en: f.en.value.trim(),
        ref_bn: f.ref_bn.value.trim(), ref_en: f.ref_en.value.trim(),
        repeat: Math.max(1, Number(f.repeat.value) || 1), audio: f.audio.value.trim(),
        title_en: d?.title_en || '', chapter: d?.chapter || 0,
      });
      return true;
    } }],
  });
}

// ---------------------------------------------------------------- dhikr
function dhikrEditor(set, data, changed) {
  const items = data.items || [];
  const group = (after) => items.map((d, i) => [d, i]).filter(([d]) => !!d.afterSalah === after);
  const row = ([d, i]) => h('div.list-item',
    h('div.grow',
      h('div.row', h('b', d.nameBn), h('span.muted.small', d.nameEn), h('span.badge.b-gold', `×${d.perSalah} after each salah`)),
      arabic(d.ar), h('div.small', d.bn), h('div.small.muted', d.en)),
    h('button.icon-btn', { title: 'Edit', onclick: () => editDhikr(d, (nd) => { items[i] = { ...d, ...nd }; changed(); }) }, '✎'));
  return h('div',
    card('After every salah',
      h('p.muted.small', 'The list itself (and each one\'s recitation) is built into the app; correct the words, meanings, virtues, references and counts here.'),
      h('div.list', group(true).map(row))),
    card('Daily targets', h('div.list', group(false).map(row))));
}

function editDhikr(d, done) {
  const t = (k, rows = 2, rtl = false) => h('textarea.inp', { value: d[k] || '', dir: rtl ? 'rtl' : 'auto', style: { minHeight: `${rows * 26 + 20}px`, ...(rtl ? { fontSize: '19px' } : {}) } });
  const f = {
    ar: t('ar', 3, true), tr: t('tr'), nameBn: input({ value: d.nameBn }), nameEn: input({ value: d.nameEn }),
    bn: t('bn'), en: t('en'), virtueBn: t('virtueBn', 4), virtueEn: t('virtueEn', 4),
    refBn: input({ value: d.refBn }), refEn: input({ value: d.refEn }),
    perSalah: input({ type: 'number', min: 1, value: d.perSalah }),
  };
  return dialog({
    title: `Edit – ${d.nameEn}`,
    wide: true,
    body: h('div',
      field('Arabic', f.ar, 'Must match a verified source (Quran text: quran.com; others: Hisn al-Muslim).'), field('Pronunciation', f.tr),
      h('div.grid.g2', field('Name (Bangla)', f.nameBn), field('Name (English)', f.nameEn)),
      h('div.grid.g2', field('Meaning (Bangla)', f.bn), field('Meaning (English)', f.en)),
      h('div.grid.g2', field('Virtue (Bangla)', f.virtueBn), field('Virtue (English)', f.virtueEn)),
      h('div.grid.g2', field('Reference (Bangla)', f.refBn), field('Reference (English)', f.refEn)),
      field('Times after each salah', f.perSalah, 'Changing it changes the daily target (× 5 salah).')),
    actions: [{ label: 'Cancel', value: null }, { label: 'Done', kind: 'primary', run: () => {
      const out = Object.fromEntries(Object.entries(f).map(([k, i]) => [k, i.value.trim()]));
      out.perSalah = Math.max(1, Number(out.perSalah) || d.perSalah);
      if (!out.ar || !out.nameBn) { toast('Arabic and the Bangla name are needed.', 'bad'); return false; }
      done(out);
      return true;
    } }],
  });
}

// ---------------------------------------------------------------- quran
async function quranInfo(body) {
  const ref = input({ placeholder: 'e.g. 2:255' });
  const out = h('div');
  clear(body).append(card('The Quran in the app',
    h('p', 'The Quran tab, Daily Quran and recitations are read live from quran.com – the Uthmani Arabic and quran.com’s translations. That keeps the Quran exactly as in a verified copy, so it is deliberately not editable here.'),
    h('p.small.muted', 'Found a problem in a translation? Report it to quran.com (Feedback on the ayah there) – the fix reaches the app automatically. You can look up any ayah below exactly as the app shows it.'),
    h('div.row', { style: { alignItems: 'flex-end', flexWrap: 'nowrap' } },
      h('div', { style: { flex: 1 } }, field('Look up an ayah', ref)),
      h('button.btn.btn-primary', { style: { marginBottom: '12px' }, onclick: (e) => act(e.currentTarget, async () => {
        const a = await fetchAyah(ref.value);
        clear(out).append(h('div.list-item', h('div.grow', h('b', `${a.surahEn} ${a.ref}`), arabic(a.ar),
          LANGS.map(([l, label]) => h('div.small', h('b', `${label}: `), a.tr[l] || '–')))));
      }) }, 'Show')),
    out));
}
