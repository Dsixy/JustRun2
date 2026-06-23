#!/usr/bin/env python3
"""Export wiki images from asset.png per wiki_images_manifest.yml."""

from __future__ import annotations

import json
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None

try:
    from PIL import Image
except ImportError:
    print("Requires: pip install Pillow pyyaml", file=sys.stderr)
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]
ATLAS = ROOT / "asset" / "image" / "asset.png"
MANIFEST = Path(__file__).with_name("wiki_images_manifest.yml")


def load_manifest() -> dict:
    text = MANIFEST.read_text(encoding="utf-8")
    if yaml is not None:
        return yaml.safe_load(text)
    # Minimal fallback without PyYAML for simple manifest
    raise SystemExit("PyYAML required: pip install pyyaml")


def export_images(manifest: dict) -> list[dict]:
    out_dir = ROOT / manifest.get("output_dir", "docs/assets/images/wiki")
    out_dir.mkdir(parents=True, exist_ok=True)

    img = Image.open(ATLAS).convert("RGBA")
    report: list[dict] = []

    for key, entry in manifest.get("images", {}).items():
        x, y, w, h = entry["rect"]
        dest = out_dir / entry["file"]
        if x < 0 or y < 0 or x + w > img.width or y + h > img.height:
            print(f"SKIP {key}: out of bounds Rect2({x},{y},{w},{h})")
            continue
        tile = img.crop((x, y, x + w, y + h))
        tile.save(dest, optimize=True)
        report.append(
            {
                "id": key,
                "file": entry["file"],
                "rect": [x, y, w, h],
                "confidence": entry.get("confidence", "sure"),
                "note": entry.get("note", ""),
                "wiki_path": f"/JustRun2/assets/images/wiki/{entry['file']}",
            }
        )
        tag = " [review]" if entry.get("confidence") == "review" else ""
        print(f"  {entry['file']}{tag}")

    index = out_dir / "manifest.json"
    index.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\n{len(report)} images -> {out_dir}")
    print(f"Index -> {index}")
    return report


def main() -> int:
    if not ATLAS.is_file():
        print(f"Missing {ATLAS}", file=sys.stderr)
        return 1
    if not MANIFEST.is_file():
        print(f"Missing {MANIFEST}", file=sys.stderr)
        return 1

    manifest = load_manifest()
    print(f"Exporting from {ATLAS.name} ...")
    export_images(manifest)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
