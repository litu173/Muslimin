# -*- coding: utf-8 -*-
"""Upazila / thana boundaries for the app (assets/geo/upazilas.json).

  python3 build_upazilas.py ADM2.geojson ADM3.geojson out.json

geoBoundaries BGD ADM2 (districts) + ADM3 (upazilas and city thanas) –
BBS / OCHA, CC BY 3.0 IGO. Each upazila gets its district (app spelling),
simplified outline (~150 m) and bounding box, so the phone can tell which
thana a GPS point is in without any server.
"""
import json, sys

adm2, adm3, out = sys.argv[1:4]

def rdp(pts, eps):
    if len(pts) < 3:
        return pts
    (x1, y1), (x2, y2) = pts[0], pts[-1]
    dx, dy = x2 - x1, y2 - y1
    n = (dx * dx + dy * dy) ** 0.5 or 1e-12
    dmax, idx = 0, 0
    for i in range(1, len(pts) - 1):
        x, y = pts[i]
        d = abs(dy * x - dx * y + x2 * y1 - y2 * x1) / n
        if d > dmax:
            dmax, idx = d, i
    if dmax <= eps:
        return [pts[0], pts[-1]]
    return rdp(pts[:idx + 1], eps)[:-1] + rdp(pts[idx:], eps)

def polys(g):
    return [g['coordinates']] if g['type'] == 'Polygon' else g['coordinates']

def inside(x, y, ring):
    c, j = False, len(ring) - 1
    for i in range(len(ring)):
        xi, yi = ring[i]; xj, yj = ring[j]
        if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi:
            c = not c
        j = i
    return c

ALIAS = {'Barisal': 'Barishal', 'Bogra': 'Bogura', 'Chittagong': 'Chattogram',
         'Comilla': 'Cumilla', 'Jessore': 'Jashore', 'Jhalokati': 'Jhalokathi',
         'Nawabganj': 'Chapai Nawabganj', 'Maulvibazar': 'Moulvibazar',
         'Netrakona': 'Netrokona', 'Khagrachari': 'Khagrachhari',
         'Brahamanbaria': 'Brahmanbaria'}
dists = [(ALIAS.get(f['properties']['shapeName'], f['properties']['shapeName']), polys(f['geometry']))
         for f in json.load(open(adm2))['features']]

res = []
for f in json.load(open(adm3))['features']:
    ps = polys(f['geometry'])
    # District: the one holding this upazila's largest ring's first inner point.
    ring0 = max((p[0] for p in ps), key=len)
    cx = sum(p[0] for p in ring0) / len(ring0); cy = sum(p[1] for p in ring0) / len(ring0)
    d = next((n for n, dp in dists if any(inside(cx, cy, p[0]) for p in dp)), None)
    if d is None:  # centroid outside (odd shapes): try ring points
        for x, y in ring0[::7]:
            d = next((n for n, dp in dists if any(inside(x, y, p[0]) for p in dp)), None)
            if d: break
    out_p = []
    # Small city thanas need a finer outline than big rural upazilas.
    for eps in (0.0015, 0.0004, 0.0001):
        for p in ps:
            ring = rdp([(round(x, 4), round(y, 4)) for x, y in p[0]], eps)
            if len(ring) >= 4:
                out_p.append([v for xy in ring for v in xy])
        if out_p:
            break
    if not out_p:  # tiny: keep the original outline
        out_p = [[round(v, 5) for xy in p[0] for v in xy[:2]] for p in ps]
    xs = [v for r in out_p for v in r[0::2]]; ys = [v for r in out_p for v in r[1::2]]
    res.append({'d': d, 't': f['properties']['shapeName'],
                'b': [min(xs), min(ys), max(xs), max(ys)], 'p': out_p})
res.sort(key=lambda r: (r['d'] or '', r['t']))
json.dump(res, open(out, 'w'), separators=(',', ':'))
print(len(res), 'upazilas; no district:', [r['t'] for r in res if not r['d']])
