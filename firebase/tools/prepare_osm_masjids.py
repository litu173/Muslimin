# -*- coding: utf-8 -*-
"""Masjids of Bangladesh from OpenStreetMap -> masjids_bd.json for the import.

  python3 prepare_osm_masjids.py <overpass.json> <ADM2.geojson> <ADM3.geojson> <out.json>

* overpass.json: Overpass `nwr[amenity=place_of_worship][religion=muslim]
  (20.5,88.0,26.7,92.7); out center tags;` (OpenStreetMap, ODbL).
* ADM2/ADM3: geoBoundaries BGD districts / upazilas (BBS, OCHA; CC BY 3.0 IGO).

Keeps points inside Bangladesh, names each masjid's district (in the app's
spelling) and upazila, tidies names, drops unnamed ones and duplicates.
"""
import json
import math
import re
import sys

src, adm2, adm3, out = sys.argv[1:5]

# App spellings (lib/data/bd_districts.dart) for geoBoundaries names.
ALIAS = {
    'Barisal': 'Barishal', 'Bogra': 'Bogura', 'Chittagong': 'Chattogram',
    'Comilla': 'Cumilla', 'Jessore': 'Jashore', 'Jhalokati': 'Jhalokathi',
    'Nawabganj': 'Chapai Nawabganj', 'Chapai Nababganj': 'Chapai Nawabganj',
    'Chapainawabganj': 'Chapai Nawabganj', 'Cox`s Bazar': "Cox's Bazar",
    'Coxs Bazar': "Cox's Bazar", 'Maulvibazar': 'Moulvibazar',
    'Netrakona': 'Netrokona', 'Khagrachari': 'Khagrachhari',
    'Brahamanbaria': 'Brahmanbaria', 'Kishoreganj': 'Kishoreganj',
}
APP = re.findall(r"\(['\"](.+?)['\"], '", open(
    sys.argv[5] if len(sys.argv) > 5 else
    '../../muslimin_app/lib/data/bd_districts.dart', encoding='utf-8').read())


def polys(geom):
    if geom['type'] == 'Polygon':
        return [geom['coordinates']]
    return geom['coordinates']


def inside(x, y, ring):
    c = False
    j = len(ring) - 1
    for i in range(len(ring)):
        xi, yi = ring[i][0], ring[i][1]
        xj, yj = ring[j][0], ring[j][1]
        if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi:
            c = not c
        j = i
    return c


def load(path):
    shapes = []
    for f in json.load(open(path))['features']:
        ps = polys(f['geometry'])
        xs = [p[0] for poly in ps for p in poly[0]]
        ys = [p[1] for poly in ps for p in poly[0]]
        shapes.append((f['properties']['shapeName'], ps,
                       (min(xs), min(ys), max(xs), max(ys))))
    return shapes


def find(shapes, x, y):
    for name, ps, (x0, y0, x1, y1) in shapes:
        if not (x0 <= x <= x1 and y0 <= y <= y1):
            continue
        for poly in ps:
            if inside(x, y, poly[0]) and not any(inside(x, y, h) for h in poly[1:]):
                return name
    return None


def district_name(n):
    n = ALIAS.get(n, n)
    if n in APP:
        return n
    low = {a.lower().replace(' ', ''): a for a in APP}
    return low.get(n.lower().replace(' ', ''), n)


GENERIC = re.compile(r'^(mosque|masjid|masjeed|mosjid|jame masjid|jame mosque|'
                     r'jama masjid|মসজিদ|জামে মসজিদ)$', re.I)
BN = re.compile('[ঀ-৿]')


def tidy(name):
    """'Baitul Hamad Jame Masjid, Mosque' -> ('Baitul Hamad Jame Masjid', '')
    'X Masjid, Lalpur - Ishwardi Hwy, Natore' -> ('X Masjid', 'Lalpur - Ishwardi Hwy, Natore')"""
    parts = [p.strip() for p in re.split(r'[,،]', name) if p.strip()]
    parts = [p for i, p in enumerate(parts) if i == 0 or not GENERIC.match(p)]
    if not parts:
        return '', ''
    return re.sub(r'\s+', ' ', parts[0])[:80], ', '.join(parts[1:])[:120]


districts, upazilas = load(adm2), load(adm3)
rows, outside, unnamed = [], 0, 0
for e in json.load(open(src))['elements']:
    lat = e.get('lat') or (e.get('center') or {}).get('lat')
    lng = e.get('lon') or (e.get('center') or {}).get('lon')
    if lat is None:
        continue
    d = find(districts, lng, lat)
    if d is None:
        outside += 1
        continue
    t = e.get('tags', {})
    raw = (t.get('name:en') or t.get('name') or t.get('name:bn') or '').strip()
    name, extra = tidy(raw)
    bn = t.get('name:bn', '').strip()
    # "Bage Jannat Jame Mosjid বাগে জান্নাত জামে মসজিদ": English + Bangla.
    if BN.search(name) and re.search('[A-Za-z]{3}', name):
        bn = bn or re.sub(r'\s+', ' ', ' '.join(re.findall('[\u0980-\u09FF][\u0980-\u09FF\\s]*', name))).strip()
        name = re.sub(r'\s+', ' ', re.sub(r'[\u0980-\u09FF]+|[()\[\]]', ' ', name)).strip(' -/')
    elif BN.search(name):
        bn = bn or name
    if len(name) < 3 or GENERIC.match(name):
        unnamed += 1
        continue
    addr = ', '.join(x for x in [
        t.get('addr:housenumber', ''), t.get('addr:street', ''),
        t.get('addr:village', ''), t.get('addr:union', '') and
        t['addr:union'] + ' Union', t.get('addr:suburb', ''), extra,
    ] if x)[:120]
    rows.append({
        'osm': f"{e['type']}/{e['id']}",
        'name': name,
        'nameBn': tidy(bn)[0] if bn else '',
        'district': district_name(d),
        'thana': find(upazilas, lng, lat) or '',
        'address': addr,
        'lat': round(lat, 7),
        'lng': round(lng, 7),
    })

# Duplicates: the same masjid mapped twice (a node and a building) within
# 60 m with the same name, or anything within 8 m.
def close(a, b, m):
    dy = (a['lat'] - b['lat']) * 111_320
    dx = (a['lng'] - b['lng']) * 111_320 * math.cos(math.radians(a['lat']))
    return dx * dx + dy * dy < m * m

rows.sort(key=lambda r: (r['lat'], r['lng']))
keep, dupes = [], 0
for r in rows:
    if any(abs(k['lat'] - r['lat']) < 0.001 and (
            close(k, r, 8) or close(k, r, 60) and
            k['name'].lower() == r['name'].lower()) for k in keep[-200:]):
        dupes += 1
        continue
    keep.append(r)

json.dump(keep, open(out, 'w'), ensure_ascii=False, indent=0)
unmapped = sorted({r['district'] for r in keep} - set(APP))
print(f'{len(keep)} masjids · {outside} outside Bangladesh · {unnamed} unnamed · '
      f'{dupes} duplicates · districts not in app list: {unmapped}')
