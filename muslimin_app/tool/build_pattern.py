"""Builds the pattern SVGs from tool/pattern_tile.svg (the exact Figma tile).

The Figma unit is 144 x 198 (four identical 72 x 99 tiles), but the artwork's
real vertical period is 99.5153 px (measured: lines leaving a tile's bottom
re-enter the next tile 0.515 px off when stacked every 99 px, which shows as
row seams). So each tile is clipped to its true period, 72 x 99.5153, and
stretched by 0.49% vertically (imperceptible) onto an exact 72 x 100 grid,
which also keeps tiles on whole pixels for browsers and Flutter.

Outputs
  assets/patterns/header_pattern.svg  8 x 3 tiles (576 x 300) for the app
  ../docs/assets/pattern.svg          2 x 2 tiles (144 x 200) for the website
"""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TILE_W, TILE_H = 72, 100          # output grid
PERIOD_H = 99.5153                # true vertical period of the artwork
OPACITY = 0.16  # as in the Figma header

tile = (ROOT / "tool/pattern_tile.svg").read_text()
paths = "\n".join(re.findall(r"<path [^>]+/>", tile))


def build(cols: int, rows: int) -> str:
    w, h = TILE_W * cols, TILE_H * rows
    out = [
        f'<svg width="{w}" height="{h}" viewBox="0 0 {w} {h}" fill="none" xmlns="http://www.w3.org/2000/svg">',
        "<defs>",
        f'<clipPath id="c"><rect width="{TILE_W}" height="{PERIOD_H}"/></clipPath>',
        f'<g id="t" transform="scale(1 {TILE_H / PERIOD_H:.6f})"><g clip-path="url(#c)">\n{paths}\n</g></g>',
        "</defs>",
        f'<g opacity="{OPACITY}">',
    ]
    for r in range(rows):
        for c in range(cols):
            out.append(f'<use href="#t" x="{c * TILE_W}" y="{r * TILE_H}"/>')
    out += ["</g>", "</svg>", ""]
    return "\n".join(out)


targets = {
    ROOT / "assets/patterns/header_pattern.svg": (8, 3),  # 576 x 300
    ROOT.parent / "docs/assets/pattern.svg": (2, 2),  # 144 x 200
}
for path, (c, r) in targets.items():
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(build(c, r))
    print(path.relative_to(ROOT.parent), f"{c * TILE_W}x{r * TILE_H}")
print(len(re.findall(r"<path ", paths)), "paths per tile")
