#!/usr/bin/env bash
# JustRun2 static validation — default parse-check; optional full import.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DO_IMPORT=false
SKIP_PARSE=false

for arg in "$@"; do
  case "$arg" in
    --import) DO_IMPORT=true ;;
    --skip-parse-check) SKIP_PARSE=true ;;
  esac
done

resolve_godot() {
  if [[ -n "${GODOT_BIN:-}" && -x "$GODOT_BIN" ]]; then
    echo "$GODOT_BIN"
    return
  fi
  if command -v godot >/dev/null 2>&1; then
    command -v godot
    return
  fi
  echo "Godot 4.x not found. Set GODOT_BIN to your Godot executable." >&2
  exit 1
}

GODOT="$(resolve_godot)"
echo "Using Godot: $GODOT"

if $DO_IMPORT; then
  echo "Importing project (script compile + resource scan)..."
  timeout 180 "$GODOT" --headless --display-driver headless --audio-driver Dummy --path "$ROOT" --import
else
  echo "Skipping full import (pass --import to enable)."
fi

if ! $SKIP_PARSE; then
  echo "Parse check (loads core .gd, does not run main menu)..."
  "$GODOT" --headless --display-driver headless --audio-driver Dummy --path "$ROOT" --script res://scripts/godot_smoke.gd
fi

if command -v gdlint >/dev/null 2>&1; then
  echo "Running gdlint..."
  gdlint script/
else
  echo "gdlint not installed — skipping (optional: pip install gdtoolkit)"
fi

echo "Validation passed."
