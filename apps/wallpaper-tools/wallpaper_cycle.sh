#!/usr/bin/env bash

set -euo pipefail

# Simple wallpaper cycler.
# - Rotates images in a directory at a fixed interval.
# - Tries several common backends: swww, feh, GNOME gsettings, KDE Plasma, XFCE.
#
# Usage:
#   ./wallpaper_cycle.sh [--dir DIR] [--interval SECONDS] [--shuffle]
#
# Defaults:
#   DIR: "$HOME/wallpapers" (change via --dir)
#   INTERVAL: 10 seconds (change via --interval)

DIR="$HOME/wallpapers"
INTERVAL=10
SHUFFLE=false

print_usage() {
  echo "Usage: $0 [--dir DIR] [--interval SECONDS] [--shuffle]" >&2
}

has() { command -v "$1" >/dev/null 2>&1; }

# Parse args
while (( "$#" )); do
  case "$1" in
    --dir)
      shift
      DIR="${1:-}"
      [[ -z "${DIR}" ]] && { echo "--dir requires a value" >&2; exit 1; }
      ;;
    --interval)
      shift
      INTERVAL="${1:-}"
      [[ -z "${INTERVAL}" ]] && { echo "--interval requires a value" >&2; exit 1; }
      ;;
    --shuffle)
      SHUFFLE=true
      ;;
    -h|--help)
      print_usage; exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      print_usage; exit 1
      ;;
  esac
  shift
done

if [[ ! -d "$DIR" ]]; then
  echo "Directory not found: $DIR" >&2
  exit 1
fi

shopt -s nullglob nocaseglob

# Backends
set_wallpaper() {
  local img="$1"

  # 1) swww (Wayland-friendly)
  if has swww; then
    # Start daemon if not running; ignore error if already started
    swww init >/dev/null 2>&1 || true
    # Try to set on all outputs when supported
    if swww img --outputs all "$img" >/dev/null 2>&1; then
      return 0
    else
      # Fallback to default behavior
      swww img "$img" >/dev/null 2>&1 && return 0
    fi
  fi

  # 2) feh (X11 WMs)
  if has feh; then
    feh --no-fehbg --bg-fill "$img" >/dev/null 2>&1 && return 0
  fi

  # 3) GNOME via gsettings
  if has gsettings; then
    local uri="file://$img"
    # Try to set both light/dark keys when available
    if gsettings writable org.gnome.desktop.background picture-uri >/dev/null 2>&1; then
      gsettings set org.gnome.desktop.background picture-uri "$uri" >/dev/null 2>&1 || true
    fi
    if gsettings writable org.gnome.desktop.background picture-uri-dark >/dev/null 2>&1; then
      gsettings set org.gnome.desktop.background picture-uri-dark "$uri" >/dev/null 2>&1 || true
    fi
    if gsettings writable org.gnome.desktop.background picture-options >/dev/null 2>&1; then
      gsettings set org.gnome.desktop.background picture-options 'zoom' >/dev/null 2>&1 || true
    fi
    # If any of the above succeeded, assume success
    # (We can't easily introspect; best-effort.)
    return 0
  fi

  # 4) KDE Plasma (5.27+: plasma-apply-wallpaperimage)
  if has plasma-apply-wallpaperimage; then
    plasma-apply-wallpaperimage "$img" >/dev/null 2>&1 && return 0
  fi

  # 5) XFCE (set all image-path props)
  if has xfconf-query; then
    local ok=false
    while IFS= read -r prop; do
      xfconf-query -c xfce4-desktop -p "$prop" -s "$img" >/dev/null 2>&1 && ok=true
    done < <(xfconf-query -c xfce4-desktop -l | grep -E "/backdrop/.*/image-path$")
    $ok && return 0
  fi

  return 1
}

gather_images() {
  local d="$1"
  # Use shell globs for common formats
  local files=( "$d"/*.jpg "$d"/*.jpeg "$d"/*.png "$d"/*.bmp "$d"/*.webp )
  # Filter out non-existent globs
  local out=()
  for f in "${files[@]}"; do
    [[ -f "$f" ]] && out+=("$f")
  done
  printf '%s\n' "${out[@]}"
}

echo "Cycling wallpapers from: $DIR (every ${INTERVAL}s)" >&2
$SHUFFLE && echo "Order: shuffled" >&2

trap 'echo "Exiting" >&2; exit 0' INT TERM

backend_ready=false

while :; do
  mapfile -t IMGS < <(gather_images "$DIR")
  if (( ${#IMGS[@]} == 0 )); then
    echo "No images found in $DIR. Supported: jpg, jpeg, png, bmp, webp" >&2
    sleep "$INTERVAL"
    continue
  fi

  if $SHUFFLE && has shuf; then
    mapfile -t IMGS < <(printf '%s\n' "${IMGS[@]}" | shuf)
  fi

  for img in "${IMGS[@]}"; do
    if set_wallpaper "$img"; then
      backend_ready=true
    else
      if ! $backend_ready; then
        echo "Could not find a supported wallpaper backend (tried: swww, feh, GNOME gsettings, Plasma, XFCE)." >&2
        echo "Install one (e.g. 'swww' or 'feh') or tell me your desktop environment to tailor this." >&2
        exit 1
      fi
    fi
    sleep "$INTERVAL"
  done
done
