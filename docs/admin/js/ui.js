// Small DOM toolkit for the admin website: elements, icons, toasts, dialogs,
// tables and formatting. Text is always set as text (never as HTML).
import { toDate } from './fb.js';

/** h('div.card#id', {onclick, class, style, ...}, ...children) */
export function h(sel, attrs, ...kids) {
  if (attrs == null || typeof attrs !== 'object' || attrs instanceof Node || Array.isArray(attrs)) {
    kids.unshift(attrs);
    attrs = {};
  }
  const [, tag = 'div', rest = ''] = sel.match(/^([a-z0-9-]*)(.*)$/i);
  const el = document.createElement(tag || 'div');
  for (const part of rest.match(/[.#][^.#]+/g) || []) {
    if (part[0] === '.') el.classList.add(part.slice(1));
    else el.id = part.slice(1);
  }
  for (const [k, v] of Object.entries(attrs)) {
    if (v == null || v === false) continue;
    if (k.startsWith('on')) el.addEventListener(k.slice(2), v);
    else if (k === 'class') el.className += ` ${v}`;
    else if (k === 'style' && typeof v === 'object') Object.assign(el.style, v);
    else if (k === 'html') el.innerHTML = v; // only ever used with our own static SVG
    else if (k in el && k !== 'list') el[k] = v;
    else el.setAttribute(k, v === true ? '' : v);
  }
  append(el, kids);
  return flat(el);
}

const nativeAppend = Element.prototype.append;
function append(el, kids) {
  for (const k of kids.flat(Infinity)) {
    if (k == null || k === false) continue;
    nativeAppend.call(el, k instanceof Node ? k : document.createTextNode(`${k}`));
  }
}

/** Our elements' append() takes lists (and skips null/false) – the native
 *  one would print a list of links as their addresses. */
function flat(el) {
  el.append = (...kids) => append(el, kids);
  return el;
}

export const clear = (el) => { el.replaceChildren(); return flat(el); };

// ---- icons (Material Symbols-style outlines, inline SVG)
const P = {
  dashboard: 'M4 13h6V4H4v9zm0 7h6v-5H4v5zm10 0h6v-9h-6v9zm0-16v5h6V4h-6z',
  masjid: 'M12 2c-.6 1.6-2.4 2.6-2.4 4.4 0 .5.1 1 .4 1.4H6v12h4v-4a2 2 0 0 1 4 0v4h4V7.8h-4c.3-.4.4-.9.4-1.4C14.4 4.6 12.6 3.6 12 2zM3 9h2v11H3zm16 0h2v11h-2z',
  users: 'M16 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm-8 0a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm0 2c-2.7 0-8 1.3-8 4v3h16v-3c0-2.7-5.3-4-8-4zm8 0c-.3 0-.7 0-1.1.1 1.2.9 2.1 2.1 2.1 3.9v3h7v-3c0-2.7-5.3-4-8-4z',
  review: 'M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z',
  flag: 'M14.4 6 14 4H5v17h2v-7h5.6l.4 2h7V6z',
  map: 'M15 5.1 9 3 3 5v16l6-2.1 6 2.1 6-2V3l-6 2.1zM15 19l-6-2.1V5l6 2.1V19z',
  bell: 'M12 22a2 2 0 0 0 2-2h-4a2 2 0 0 0 2 2zm6-6v-5c0-3.1-1.6-5.6-4.5-6.3V4a1.5 1.5 0 0 0-3 0v.7C7.6 5.4 6 7.9 6 11v5l-2 2v1h16v-1l-2-2z',
  settings: 'M19.4 13a7.6 7.6 0 0 0 0-2l2.1-1.6-2-3.5-2.5 1a7.4 7.4 0 0 0-1.7-1L15 3h-4l-.4 2.7c-.6.3-1.2.6-1.7 1l-2.5-1-2 3.5L6.6 11a7.6 7.6 0 0 0 0 2l-2.1 1.6 2 3.5 2.5-1c.5.4 1.1.7 1.7 1L11 21h4l.4-2.7c.6-.3 1.2-.6 1.7-1l2.5 1 2-3.5-2.2-1.8zM13 15.5a3.5 3.5 0 1 1 0-7 3.5 3.5 0 0 1 0 7z',
  log: 'M13 3a9 9 0 0 0-9 9H1l4 4 4-4H6a7 7 0 1 1 2.1 5l-1.4 1.4A9 9 0 1 0 13 3zm-1 5v5l4.3 2.5.7-1.2-3.5-2.1V8z',
  activity: 'M3 17h4l3-8 4 12 3-7h4v-2h-5.3L14 15 10 3l-4.4 12H3z',
  search: 'M15.5 14h-.8l-.3-.3A6.5 6.5 0 1 0 14 15.5l.3.3v.8l5 5 1.5-1.5-5-5zm-6 0a4.5 4.5 0 1 1 0-9 4.5 4.5 0 0 1 0 9z',
  logout: 'M10 17v-3H3v-4h7V7l5 5-5 5zm9-14H12v2h7v14h-7v2h7a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2z',
  back: 'M20 11H7.8l5.6-5.6L12 4l-8 8 8 8 1.4-1.4L7.8 13H20z',
  plus: 'M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6z',
  trash: 'M6 19a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z',
  close: 'M19 6.4 17.6 5 12 10.6 6.4 5 5 6.4 10.6 12 5 17.6 6.4 19 12 13.4 17.6 19 19 17.6 13.4 12z',
  open: 'M19 19H5V5h7V3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7h-2v7zM14 3v2h3.6l-9.8 9.8 1.4 1.4L19 6.4V10h2V3h-7z',
  undo: 'M12.5 8c-2.6 0-5 1-6.9 2.6L2 7v9h9l-3.6-3.6A8 8 0 0 1 20.1 16l2.4-.8A10.5 10.5 0 0 0 12.5 8z',
  send: 'M2 21 23 12 2 3v7l15 2-15 2z',
  menu: 'M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z',
  check: 'M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z',
  pin: 'M12 2a7 7 0 0 0-7 7c0 5.3 7 13 7 13s7-7.7 7-13a7 7 0 0 0-7-7zm0 9.5a2.5 2.5 0 1 1 0-5 2.5 2.5 0 0 1 0 5z',
  refresh: 'M17.7 6.3A8 8 0 1 0 19.7 14h-2.1a6 6 0 1 1-1.4-6.3L13 11h7V4l-2.3 2.3z',
};
export function icon(name, size = 20) {
  const s = h('span.ic', { html: `<svg viewBox="0 0 24 24" width="${size}" height="${size}" aria-hidden="true"><path d="${P[name] || P.dashboard}"/></svg>` });
  return s;
}

// ---- formatting
export function fmtDate(v, withTime = true) {
  const d = toDate(v);
  if (!d) return '–';
  return d.toLocaleString('en-GB', withTime
    ? { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' }
    : { day: 'numeric', month: 'short', year: 'numeric' });
}
export function ago(v) {
  const d = toDate(v);
  if (!d) return '–';
  const s = (Date.now() - d.getTime()) / 1000;
  if (s < 60) return 'just now';
  if (s < 3600) return `${Math.floor(s / 60)} min ago`;
  if (s < 86400) return `${Math.floor(s / 3600)} h ago`;
  if (s < 86400 * 30) return `${Math.floor(s / 86400)} d ago`;
  return fmtDate(d, false);
}
export const num = (n) => (n ?? 0).toLocaleString('en-US');

export function badge(text, kind = '') {
  return h(`span.badge${kind ? `.b-${kind}` : ''}`, text);
}
export const statusBadge = (s) => badge(s || 'unknown', {
  approved: 'ok', pending: 'warn', rejected: 'bad', suspended: 'mute',
  open: 'warn', resolved: 'ok', queued: 'warn', done: 'ok', failed: 'bad',
}[s] || '');

// ---- toasts
export function toast(msg, kind = 'ok') {
  const host = document.getElementById('toasts');
  const t = h(`div.toast.t-${kind}`, msg);
  host.append(t);
  setTimeout(() => t.classList.add('out'), 3200);
  setTimeout(() => t.remove(), 3700);
}

// ---- dialogs
/** Opens a dialog; resolves with the clicked action's value (or null). */
export function dialog({ title, body, actions = [{ label: 'Close', value: null }], wide }) {
  return new Promise((resolve) => {
    const close = (v) => { back.remove(); resolve(v); };
    const box = h(`div.dialog${wide ? '.wide' : ''}`,
      h('div.dlg-head', h('h3', title), h('button.icon-btn', { onclick: () => close(null), title: 'Close' }, icon('close'))),
      h('div.dlg-body', body),
      h('div.dlg-actions', actions.map((a) => h(`button.btn${a.kind ? `.btn-${a.kind}` : ''}`, {
        onclick: async () => {
          if (a.run) {
            const v = await a.run();
            if (v === false) return; // validation failed – stay open
            close(v ?? a.value);
          } else close(a.value);
        },
      }, a.label))));
    const back = h('div.backdrop', { onclick: (e) => { if (e.target === back) close(null); } }, box);
    document.body.append(back);
    box.querySelector('input,textarea,select')?.focus();
  });
}

export async function confirmDialog(title, text, { danger = false, ok = 'Confirm' } = {}) {
  return dialog({
    title,
    body: h('p', text),
    actions: [{ label: 'Cancel', value: false }, { label: ok, value: true, kind: danger ? 'danger' : 'primary' }],
  });
}

/** Runs an async action with a busy button and a toast. */
export async function act(btn, fn, okMsg) {
  if (btn) { btn.disabled = true; btn.classList.add('busy'); }
  try {
    const r = await fn();
    if (okMsg) toast(okMsg);
    return r;
  } catch (e) {
    console.error(e);
    toast(friendlyError(e), 'bad');
    return undefined;
  } finally {
    if (btn) { btn.disabled = false; btn.classList.remove('busy'); }
  }
}

export function friendlyError(e) {
  const c = `${e?.code || ''}`;
  if (c.includes('permission-denied')) return 'Not allowed – the database rules refused this (deploy the latest rules?).';
  if (c.includes('failed-precondition')) return 'A database index is missing or still building – deploy indexes and wait a few minutes.';
  if (c.includes('resource-exhausted')) return 'Daily free database quota used up – try again after midnight (US Pacific).';
  if (c.includes('unavailable')) return 'Offline or the database is unreachable.';
  return e?.message || `${e}`;
}

// ---- layout bits
export const spinner = () => h('div.spin-wrap', h('div.spinner'));
export const empty = (text) => h('div.empty', text);
export function card(title, ...body) {
  return h('section.card', title ? h('div.card-head', typeof title === 'string' ? h('h2', title) : title) : null, ...body);
}
export function field(label, input, hint) {
  return h('label.field', h('span.f-label', label), input, hint ? h('span.f-hint', hint) : null);
}
export function input(attrs = {}) { return h('input.inp', attrs); }
export function select(options, value, attrs = {}) {
  return h('select.inp', attrs, options.map((o) => {
    const [v, l] = Array.isArray(o) ? o : [o, o];
    return h('option', { value: v, selected: v === value }, l);
  }));
}
export function tabs(items, active, onPick) {
  return h('div.tabs', items.map(([id, label, n]) => h(`button.tab${id === active ? '.on' : ''}`, { onclick: () => onPick(id) },
    label, n != null ? h('span.tab-n', num(n)) : null)));
}

/** A table: cols = [{label, cell: (row) => node|string, class?}] */
export function table(cols, rows, { onRow, emptyText = 'Nothing here.' } = {}) {
  if (!rows.length) return empty(emptyText);
  return h('div.tbl-wrap', h('table.tbl',
    h('thead', h('tr', cols.map((c) => h('th', { class: c.class }, c.label)))),
    h('tbody', rows.map((r) => h(`tr${onRow ? '.click' : ''}`, { onclick: onRow ? () => onRow(r) : null },
      cols.map((c) => h('td', { class: c.class }, c.cell(r))))))));
}

export const go = (hash) => { location.hash = hash; };
export const link = (hash, text) => h('a', { href: `#${hash}`, onclick: (e) => e.stopPropagation() }, text);
