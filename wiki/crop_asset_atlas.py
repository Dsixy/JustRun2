#!/usr/bin/env python3
"""Crop asset/image/asset.png into wiki-ready slices.

Outputs:
  asset/image/slices/grid/     — full 100×100 grid (Rect2-friendly names)
  asset/image/slices/by_rect/  — unique regions referenced in project files
  asset/image/slices/named/    — same crops, semantic filenames from scenes
  asset/image/slices/manifest.json

Godot uses Rect2(x, y, width, height). Filenames use {x}_{y}_{w}_{h}.png.
"""

from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Pillow required: pip install Pillow", file=sys.stderr)
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]
ATLAS_PATH = ROOT / "asset" / "image" / "asset.png"
OUT_DIR = ROOT / "asset" / "image" / "slices"
CELL = 100

ASSET_REF = re.compile(r'res://asset/image/asset\.png')
RECT2 = re.compile(r"Rect2\(\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\)")
EXT_RESOURCE = re.compile(
    r'^\[ext_resource[^\]]*path="([^"]+)"[^\]]*id="([^"]+)"',
    re.MULTILINE,
)
SUB_ATLAS = re.compile(
    r'\[sub_resource type="AtlasTexture" id="([^"]+)"\]\s*\n'
    r'(?:[^\[]*\n)*?'
    r'atlas = ExtResource\("([^"]+)"\)\s*\n'
    r'region = Rect2\(\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\)',
    re.MULTILINE,
)
ATLAS_REGION = re.compile(
    r'atlas_region":\s*Rect2\(\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\)'
)


def rect_key(x: int, y: int, w: int, h: int) -> tuple[int, int, int, int]:
    return (x, y, w, h)


def rect_filename(x: int, y: int, w: int, h: int) -> str:
    return f"{x}_{y}_{w}_{h}.png"


def crop_and_save(img: Image.Image, x: int, y: int, w: int, h: int, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if x < 0 or y < 0 or x + w > img.width or y + h > img.height:
        print(f"  skip out-of-bounds {dest.name}: Rect2({x}, {y}, {w}, {h})")
        return
    tile = img.crop((x, y, x + w, y + h))
    tile.save(dest, optimize=True)


def parse_tscn_regions(text: str) -> list[tuple[int, int, int, int]]:
    asset_ids: set[str] = set()
    for _path, ext_id in EXT_RESOURCE.findall(text):
        if ASSET_REF.search(_path.replace("\\", "/")):
            asset_ids.add(ext_id)

    regions: list[tuple[int, int, int, int]] = []
    if asset_ids:
        for _sub_id, ext_id, x, y, w, h in SUB_ATLAS.findall(text):
            if ext_id in asset_ids:
                regions.append((int(x), int(y), int(w), int(h)))

    # Fallback: any Rect2 near asset.png mention in same file
    if not regions and ASSET_REF.search(text):
        regions.extend(
            (int(x), int(y), int(w), int(h)) for x, y, w, h in RECT2.findall(text)
        )

    return regions


def parse_gd_regions(text: str) -> list[tuple[int, int, int, int]]:
    if "asset/image/asset.png" not in text and "asset.png" not in text:
        return []
    regions: list[tuple[int, int, int, int]] = []
    for x, y, w, h in ATLAS_REGION.findall(text):
        regions.append((int(x), int(y), int(w), int(h)))
    if not regions:
        for x, y, w, h in RECT2.findall(text):
            regions.append((int(x), int(y), int(w), int(h)))
    return regions


def collect_references() -> dict[tuple[int, int, int, int], list[str]]:
    refs: dict[tuple[int, int, int, int], list[str]] = defaultdict(list)
    patterns = ("scene/**/*.tscn", "resource/**/*.tres", "script/**/*.gd")

    for pattern in patterns:
        for path in ROOT.glob(pattern):
            rel = path.relative_to(ROOT).as_posix()
            text = path.read_text(encoding="utf-8", errors="replace")
            if not ASSET_REF.search(text) and "asset/image/asset.png" not in text:
                if path.suffix != ".gd":
                    continue
            regions = (
                parse_tscn_regions(text)
                if path.suffix in {".tscn", ".tres"}
                else parse_gd_regions(text)
            )
            for r in regions:
                if r not in refs[r] or rel not in refs[r]:
                    refs[r].append(rel)

    return refs


def export_grid(img: Image.Image) -> list[dict]:
    entries: list[dict] = []
    cols = img.width // CELL
    rows = img.height // CELL
    grid_dir = OUT_DIR / "grid"

    for row in range(rows):
        for col in range(cols):
            x, y = col * CELL, row * CELL
            name = f"{x}_{y}_{CELL}_{CELL}.png"
            dest = grid_dir / name
            crop_and_save(img, x, y, CELL, CELL, dest)
            entries.append(
                {
                    "file": f"grid/{name}",
                    "rect": [x, y, CELL, CELL],
                    "kind": "grid",
                }
            )

    return entries


def safe_name(path: str) -> str:
    return path.replace("/", "__").replace("\\", "__").replace(".", "_")


def main() -> int:
    if not ATLAS_PATH.is_file():
        print(f"Missing atlas: {ATLAS_PATH}", file=sys.stderr)
        return 1

    img = Image.open(ATLAS_PATH).convert("RGBA")
    print(f"Atlas: {ATLAS_PATH} ({img.width}x{img.height})")

    refs = collect_references()
    print(f"Found {len(refs)} unique Rect2 regions in project files")

    by_rect_dir = OUT_DIR / "by_rect"
    named_dir = OUT_DIR / "named"
    manifest_entries: list[dict] = []

    # Full 100×100 grid
    grid_entries = export_grid(img)
    print(f"Grid: {len(grid_entries)} tiles -> {OUT_DIR / 'grid'}")

    # Unique referenced regions
    for (x, y, w, h), sources in sorted(refs.items()):
        fname = rect_filename(x, y, w, h)
        by_dest = by_rect_dir / fname
        crop_and_save(img, x, y, w, h, by_dest)

        for src in sources:
            stem = safe_name(src)
            named_dest = named_dir / f"{stem}__{fname}"
            crop_and_save(img, x, y, w, h, named_dest)

        manifest_entries.append(
            {
                "file": f"by_rect/{fname}",
                "rect": [x, y, w, h],
                "kind": "referenced",
                "sources": sorted(sources),
                "named_copies": [
                    f"named/{safe_name(s)}__{fname}" for s in sorted(sources)
                ],
            }
        )

    manifest = {
        "source": "asset/image/asset.png",
        "size": [img.width, img.height],
        "cell_size": CELL,
        "grid_cells": len(grid_entries),
        "referenced_regions": len(manifest_entries),
        "output_dir": "asset/image/slices",
        "usage": {
            "wiki_img": "../assets/images/slices/by_rect/{x}_{y}_{w}_{h}.png",
            "rect2": "Rect2(x, y, width, height) matches filename",
        },
        "entries": manifest_entries,
        "grid": grid_entries,
    }

    manifest_path = OUT_DIR / "manifest.json"
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    print(f"Referenced: {len(manifest_entries)} -> {by_rect_dir}")
    print(f"Named copies -> {named_dir}")
    print(f"Manifest -> {manifest_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
