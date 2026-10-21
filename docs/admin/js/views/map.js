// Map picker (Leaflet + OpenStreetMap) and place lookup (Nominatim).
import { h, icon, dialog, input, toast } from '../ui.js';

const tiles = () => L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
  maxZoom: 19, attribution: '© OpenStreetMap contributors',
});

/** A small read-only map with one pin. */
export function miniMap(el, lat, lng) {
  const map = L.map(el, { scrollWheelZoom: false }).setView([lat, lng], 16);
  tiles().addTo(map);
  L.marker([lat, lng]).addTo(map);
  return map;
}

/** Lets the admin place a pin; resolves {lat, lng} or null. */
export async function pickOnMap(start, title = 'Pick location') {
  let pos = { ...start };
  const box = h('div.map.tall');
  const coords = h('span.muted.small', `${pos.lat.toFixed(6)}, ${pos.lng.toFixed(6)}`);
  const q = input({ placeholder: 'Search a place (OpenStreetMap)…' });
  let map, marker;
  const move = (lat, lng, zoom) => {
    pos = { lat, lng };
    marker.setLatLng([lat, lng]);
    if (zoom) map.setView([lat, lng], zoom);
    coords.textContent = `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
  };
  setTimeout(() => {
    map = L.map(box).setView([pos.lat, pos.lng], 16);
    tiles().addTo(map);
    marker = L.marker([pos.lat, pos.lng], { draggable: true }).addTo(map);
    marker.on('dragend', () => { const p = marker.getLatLng(); move(p.lat, p.lng); });
    map.on('click', (e) => move(e.latlng.lat, e.latlng.lng));
  }, 50);
  const search = async () => {
    if (!q.value.trim()) return;
    try {
      const r = await fetch(`https://nominatim.openstreetmap.org/search?format=jsonv2&limit=1&q=${encodeURIComponent(q.value.trim())}`);
      const [hit] = await r.json();
      if (!hit) { toast('Place not found.', 'bad'); return; }
      move(+hit.lat, +hit.lon, 17);
    } catch { toast('Search failed.', 'bad'); }
  };
  q.onkeydown = (e) => { if (e.key === 'Enter') { e.preventDefault(); search(); } };
  const ok = await dialog({
    title,
    wide: true,
    body: h('div',
      h('div.row', { style: { marginBottom: '10px' } }, h('div.search', icon('search'), q), h('button.btn', { onclick: search }, 'Find')),
      box,
      h('div.row', { style: { marginTop: '8px' } }, h('span.muted.small', 'Click the map or drag the pin.'), h('div.grow'), coords)),
    actions: [{ label: 'Cancel', value: false }, { label: 'Use this spot', value: true, kind: 'primary' }],
  });
  return ok ? pos : null;
}

/** Country code and names for a point (OpenStreetMap), or null. */
export async function placeOf(lat, lng) {
  try {
    const r = await fetch(`https://nominatim.openstreetmap.org/reverse?format=jsonv2&zoom=14&accept-language=en&lat=${lat}&lon=${lng}`);
    const j = await r.json();
    const a = j.address || {};
    return {
      country: (a.country_code || '').toUpperCase(),
      region: a.city || a.town || a.state_district || a.state || a.county || '',
      area: a.suburb || a.neighbourhood || a.city_district || a.village || a.town || '',
    };
  } catch { return null; }
}
