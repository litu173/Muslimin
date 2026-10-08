"""Builds assets/brand/app_icon.svg: one thick gold line running edge to
edge as an Alhambra-style arcade (cusped, multi-lobed arches) over the deep
green with the app's header pattern faintly behind it.

    python3 tool/build_app_icon.py
"""
import math, re, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
S = 1024
GREEN = '#002828'
GOLD = '#E2B64C'
STROKE = 40
BASE = 790  # ground line


def lobes(points, bulge=0.62, ends=1.6):
    """Cusped lobes between consecutive points; the first and last segment
    rise gently from the springing point instead of curling under it."""
    d = ''
    last = len(points) - 2
    for i, ((x0, y0), (x1, y1)) in enumerate(zip(points, points[1:])):
        chord = math.hypot(x1 - x0, y1 - y0)
        r = chord * (ends if i in (0, last) else bulge)
        d += f' A{r:.1f} {r:.1f} 0 0 1 {x1:.1f} {y1:.1f}'
    return d


def pointed(x0, x1, spring, apex, n):
    """Points on a two-centred pointed arch from (x0,spring) to (x1,spring)."""
    w = (x1 - x0) / 2
    h = spring - apex
    r = (w * w + h * h) / (2 * w)
    pts = []
    half = n // 2
    a_end = math.asin(h / r)
    for i in range(half + 1):  # left half, centred on the right
        a = a_end * i / half
        pts.append((x0 + r - r * math.cos(a), spring - r * math.sin(a)))
    for i in range(half - 1, -1, -1):  # right half, mirrored
        a = a_end * i / half
        pts.append((x1 - r + r * math.cos(a), spring - r * math.sin(a)))
    return pts


def round_arch(x0, x1, spring, n, lift=0.0):
    """Points on a horseshoe-ish round arch."""
    cx, r = (x0 + x1) / 2, (x1 - x0) / 2
    pts = []
    for i in range(n + 1):
        a = math.pi * i / n
        pts.append((cx - r * math.cos(a), spring - r * math.sin(a) * (1 + lift)))
    return pts


# Three arches – a big rounded one in the middle, a small one either side –
# meeting at their springing points; the line runs on to both edges.
SPRING = 690
arches = [
    (150, 320, 5, 0.40),
    (320, 704, 7, 0.80),
    (704, 874, 5, 0.40),
]
d = f'M-30 {SPRING} H{arches[0][0]}'
for x0, x1, n, lift in arches:
    d += lobes(round_arch(x0, x1, SPRING, n, lift), 0.62)
d += f' H{S + 30}'
pattern = (ROOT / 'assets/patterns/header_pattern.svg').read_text()
defs = re.search(r'<defs>(.*)</defs>', pattern, re.S).group(1)

HEAD = f'''<svg width="{S}" height="{S}" viewBox="0 0 {S} {S}" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<defs>{defs}
<pattern id="p" width="72" height="99.5153" patternUnits="userSpaceOnUse" patternTransform="scale(2.4)"><use href="#t" xlink:href="#t"/></pattern>
</defs>
'''
BG = f'''<rect width="{S}" height="{S}" fill="{GREEN}"/>
<rect width="{S}" height="{S}" fill="url(#p)" opacity="0.22"/>
'''


def line(path, scale=1.0):
    """The gold line; [scale] shrinks it about the centre (stroke kept)."""
    t = (f' transform="translate({S / 2} {S / 2}) scale({scale}) '
         f'translate({-S / 2} {-S / 2})"') if scale != 1 else ''
    return (f'<path d="{path}"{t} fill="none" stroke="{GOLD}" '
            f'stroke-width="{STROKE / scale:.1f}" stroke-linecap="round" '
            'stroke-linejoin="round"/>\n')


# Android adaptive icons show only the middle ~66% and mask it to the
# launcher's shape: the arches shrink into that safe zone while the line
# still runs out past both edges.
SAFE = 0.64
wide = d.replace('M-30 ', f'M{-S} ').replace(f'H{S + 30}', f'H{2 * S}')
files = {
    'app_icon': HEAD + BG + line(d) + '</svg>\n',
    'app_icon_bg': HEAD + BG + '</svg>\n',
    'app_icon_fg': HEAD + line(wide, SAFE) + '</svg>\n',
}
brand = ROOT / 'assets/brand'
for name, svg in files.items():
    (brand / f'{name}.svg').write_text(svg)
    try:  # PNGs for flutter_launcher_icons (needs cairosvg + cairo)
        import cairosvg
        cairosvg.svg2png(bytestring=svg.encode(), write_to=str(brand / f'{name}.png'),
                         output_width=S, output_height=S)
    except ImportError:
        pass
    print(name)
