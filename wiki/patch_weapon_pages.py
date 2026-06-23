#!/usr/bin/env python3
"""Insert weapon icons into docs/wiki/weapons/*.md if export exists."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WEAPONS_DIR = ROOT / "docs" / "wiki" / "weapons"
ICON_DIR = ROOT / "docs" / "assets" / "images" / "wiki"
MARKER = "<!-- wiki-weapon-header -->"


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
    return ["", "</div>", "</div>", "</div>", ""]


def _is_table_line(line: str) -> bool:
    s = line.strip()
    return s.startswith("|") and s.endswith("|")


def patch_weapon_pages() -> None:
    for md in sorted(WEAPONS_DIR.glob("*.md")):
        if md.name in {"index.md", "implemented.md", "planned.md"}:
            continue
        key = md.stem
        icon = ICON_DIR / f"weapon_{key}.png"
        if not icon.is_file():
            continue
        text = md.read_text(encoding="utf-8-sig")
        if MARKER in text or f"weapon_{key}.png" in text:
            continue
        lines = text.splitlines()
        if not lines:
            continue
        first = lines[0].lstrip("\ufeff")
        if not first.startswith("# "):
            continue
        title = first[2:].strip()
        lines[0] = first

        i = 1
        while i < len(lines) and not _is_table_line(lines[i]):
            i += 1
        if i >= len(lines):
            block = (
                _build_header(title, key)
                + ["| 字段 | 值 |", "|------|-----|", f"| **资源 Key** | `{key}` |"]
                + _build_header_close()
            )
            new_text = "\n".join(lines[:1] + block + lines[1:])
        else:
            table, after = [], i
            while after < len(lines) and _is_table_line(lines[after]):
                table.append(lines[after])
                after += 1
            block = _build_header(title, key) + table + _build_header_close()
            new_text = "\n".join(lines[:1] + block + lines[after:])

        md.write_text(new_text if new_text.endswith("\n") else new_text + "\n", encoding="utf-8")
        print(f"  patched {md.name}")


if __name__ == "__main__":
    patch_weapon_pages()
