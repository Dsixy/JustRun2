#!/usr/bin/env python3
"""Reflow weapon pages: icon + meta table side-by-side (wiki-weapon-sheet)."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WEAPONS_DIR = ROOT / "docs" / "wiki" / "weapons"
ICON_DIR = ROOT / "docs" / "assets" / "images" / "wiki"
MARKER = "<!-- wiki-weapon-header -->"
ICON_RE = re.compile(
    r"/JustRun2/assets/images/wiki/weapon_([a-z0-9_]+)\.png", re.I
)


def _is_table_line(line: str) -> bool:
    s = line.strip()
    return s.startswith("|") and s.endswith("|")


def _extract_table(lines: list[str], start: int) -> tuple[list[str], int]:
    table: list[str] = []
    i = start
    while i < len(lines) and _is_table_line(lines[i]):
        table.append(lines[i])
        i += 1
    return table, i


def _build_header(title: str, key: str) -> list[str]:
    return [
        "",
        MARKER,
        '<div class="wiki-weapon-sheet" markdown="1">',
        '<div class="wiki-weapon-sheet__grid" markdown="1">',
        f'<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_{key}.png" alt="{title}" width="96" height="96"></div>',
        '<div class="wiki-weapon-sheet__meta" markdown="1">',
        "",
    ]


def _build_header_close() -> list[str]:
    return [
        "",
        "</div>",
        "</div>",
        "</div>",
        "",
    ]


def _strip_header_block(lines: list[str]) -> tuple[str, list[str], int]:
    """Return title, body lines after header block, and index where rest starts."""
    first = lines[0].lstrip("\ufeff")
    title = first[2:].strip() if first.startswith("# ") else ""

    i = 1
    # Skip until past wiki-weapon-sheet closing div or first ## / ---
    if MARKER in "\n".join(lines):
        depth = 0
        started = False
        while i < len(lines):
            line = lines[i]
            if "<div" in line and "wiki-weapon" in line:
                depth += line.count("<div")
                started = True
            if started:
                depth -= line.count("</div>")
                i += 1
                if depth <= 0 and started:
                    break
                continue
            if line.strip().startswith("<!-- wiki-weapon"):
                i += 1
                continue
            break
        # Drop orphan closing divs left by older header formats
        while i < len(lines) and lines[i].strip() == "</div>":
            i += 1
    else:
        while i < len(lines):
            s = lines[i].strip()
            if not s or "wiki-weapon-icon" in s or s.startswith("<"):
                i += 1
                continue
            if _is_table_line(lines[i]):
                _, i = _extract_table(lines, i)
                continue
            break

    while i < len(lines) and not lines[i].strip():
        i += 1
    return title, lines, i


def reflow_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8-sig")
    lines = text.splitlines()
    if not lines:
        return False

    key = path.stem
    if not (ICON_DIR / f"weapon_{key}.png").is_file():
        return False

    m = ICON_RE.search(text)
    if m:
        key = m.group(1)

    title, _, body_start = _strip_header_block(lines)
    if not title:
        return False

    # Find meta table in remaining body
    i = body_start
    while i < len(lines) and not _is_table_line(lines[i]):
        i += 1
    if i >= len(lines):
        return False

    table_lines, after_table = _extract_table(lines, i)
    if len(table_lines) < 2:
        return False

    rest = lines[after_table:]
    while rest and not rest[0].strip():
        rest = rest[1:]

    new_lines = [f"# {title}"] + _build_header(title, key) + table_lines + _build_header_close() + rest
    path.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
    return True


def main() -> None:
    count = 0
    for md in sorted(WEAPONS_DIR.glob("*.md")):
        if md.name in {"index.md", "implemented.md", "planned.md"}:
            continue
        if reflow_file(md):
            print(f"  reflowed {md.name}")
            count += 1
    print(f"\n{count} weapon pages updated")


if __name__ == "__main__":
    main()
