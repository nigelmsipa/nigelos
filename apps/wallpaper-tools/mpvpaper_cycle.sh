#!/usr/bin/env bash

set -euo pipefail

# Video wallpaper cycler for mpvpaper
# - Rotates videos in a directory at a fixed interval
# - Kills current mpvpaper and starts next video
#
# Usage:
#   ./mpvpaper_cycle.sh [--dir DIR] [--interval SECONDS] [--monitor MONITOR] [--shuffle]
#
# Defaults:
#   DIR: "$HOME/Downloads/mpvpaper"
#   INTERVAL: 300 seconds (5 minutes)
#   MONITOR: HDMI-A-1
#   SHUFFLE: false

DIR="${HOME}/Downloads/mpvpaper"
INTERVAL=300
MONITOR="HDMI-A-1"
SHUFFLE=false
MPVPAPER_BIN="${HOME}/.local/bin/mpvpaper"

print_usage() {
  echo "Usage: $0 [--dir DIR] [--interval SECONDS] [--monitor MONITOR] [--shuffle]" >&2
}

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
    --monitor)
      shift
      MONITOR="${1:-}"
      [[ -z "${MONITOR}" ]] && { echo "--monitor requires a value" >&2; exit 1; }
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

if [[ ! -f "$MPVPAPER_BIN" ]]; then
  echo "mpvpaper not found at $MPVPAPER_BIN" >&2
  exit 1
fi

shopt -s nullglob nocaseglob

gather_videos() {
  local d="$1"
  # Common video formats
  local files=( "$d"/*.mp4 "$d"/*.webm "$d"/*.mkv "$d"/*.avi "$d"/*.mov )
  # Filter out non-existent globs
  local out=()
  for f in "${files[@]}"; do
    [[ -f "$f" ]] && out+=("$f")
  done
  printf '%s\n' "${out[@]}"
}

kill_mpvpaper() {
  pkill -f "mpvpaper.*$MONITOR" >/dev/null 2>&1 || true
}

play_video() {
  local vid="$1"
  # Kill existing mpvpaper process for this monitor
  kill_mpvpaper

  # Give it a moment to fully exit
  sleep 1

  # Start new video
  "$MPVPAPER_BIN" -f -o "no-audio loop" "$MONITOR" "$vid" >/dev/null 2>&1 &
}

echo "Cycling video wallpapers from: $DIR (every ${INTERVAL}s)" >&2
echo "Monitor: $MONITOR" >&2
[[ "$SHUFFLE" == "true" ]] && echo "Order: shuffled" >&2 || echo "Order: sequential" >&2

trap 'echo "Received signal, exiting gracefully" >&2; kill_mpvpaper; exit 0' SIGINT SIGTERM

while :; do
  mapfile -t VIDS < <(gather_videos "$DIR")
  if (( ${#VIDS[@]} == 0 )); then
    echo "No videos found in $DIR. Supported: mp4, webm, mkv, avi, mov" >&2
    sleep "$INTERVAL"
    continue
  fi

  if [[ "$SHUFFLE" == "true" ]] && command -v shuf >/dev/null 2>&1; then
    mapfile -t VIDS < <(printf '%s\n' "${VIDS[@]}" | shuf)
  fi

  for vid in "${VIDS[@]}"; do
    echo "Playing: $(basename "$vid")" >&2
    play_video "$vid"
    sleep "$INTERVAL"
  done
done
