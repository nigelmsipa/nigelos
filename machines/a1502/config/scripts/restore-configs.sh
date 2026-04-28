#!/usr/bin/env bash
set -euo pipefail
for d in hypr waybar rofi kitty eww ags quickshell; do
  src="$PWD/config-backup/$d"
  dst="$HOME/.config/$d"
  [ -d "$src" ] || { echo "skip $d (no backup)"; continue; }
  rm -rf "$dst"
  mkdir -p "$dst"
  cp -a "$src/." "$dst/"
  echo "restored: $d"
done
echo "done."
