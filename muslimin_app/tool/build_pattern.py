"""Builds the pattern SVGs from tool/pattern_tile.svg (the exact Figma tile).

The Figma repeat unit is 144 x 198: four identical 72 x 99 tiles. Each tile
is clipped to its own 72 x 99 box and laid out on an exact 72 / 99 grid, so
repeats meet seamlessly at any size.

Outputs
  assets/patterns/header_pattern.svg  8 x 3 tiles (576 x 297) for the app
  ../docs/assets/pattern.svg          2 x 2 tiles (144 x 198) for the website
"""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TILE_W, TILE_H = 72, 99
OPACITY = 0.16  # as in the Figma header

tile = (ROOT / "tool/pattern_tile.svg").read_text()
paths = "\n".join(re.findall(r"<path [^>]+/>", tile))


def build(cols: int, rows: int) -> str:
    w, h = TILE_W * cols, TILE_H * rows
    out = [
        f'<svg width="{w}" height="{h}" viewBox="0 0 {w} {h}" fill="none" xmlns="http://www.w3.org/2000/svg">',
        "<defs>",
        f'<clipPath id="c"><rect width="{TILE_W}" height="{TILE_H}"/></clipPath>',
        f'<g id="t" clip-path="url(#c)">\n{paths}\n</g>',
        "</defs>",
        f'<g opacity="{OPACITY}">',
    ]
    for r in range(rows):
        for c in range(cols):
            out.append(f'<use href="#t" x="{c * TILE_W}" y="{r * TILE_H}"/>')
    out += ["</g>", "</svg>", ""]
    return "\n".join(out)


targets = {
    ROOT / "assets/patterns/header_pattern.svg": (8, 3),
    ROOT.parent / "docs/assets/pattern.svg": (2, 2),
}
for path, (c, r) in targets.items():
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(build(c, r))
    print(path.relative_to(ROOT.parent), f"{c * TILE_W}x{r * TILE_H}")
print(len(re.findall(r"<path ", paths)), "paths per tile")
