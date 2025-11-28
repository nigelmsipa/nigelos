#!/usr/bin/env bash

# Video wallpaper switcher - manually cycle to next video
# Usage: ./mpvpaper_next.sh [--dir DIR] [--monitor MONITOR]

DIR="${HOME}/Downloads/mpvpaper"
MONITOR="HDMI-A-1"
MPVPAPER_BIN="${HOME}/.local/bin/mpvpaper"
STATE_FILE="${HOME}/.cache/mpvpaper_current"

# Parse args
while (( "$#" )); do
  case "$1" in
    --dir)
      shift
      DIR="$1"
      ;;
    --monitor)
      shift
      MONITOR="$1"
      ;;
    -h|--help)
      echo "Usage: $0 [--dir DIR] [--monitor MONITOR]"
      exit 0
      ;;
    *)
      shift
      ;;
  esac
  shift
done

mkdir -p "$(dirname "$STATE_FILE")"

# Get list of videos
shopt -s nullglob nocaseglob
VIDEOS=( "$DIR"/*.{mp4,webm,mkv,avi,mov} )
VIDEOS=( $(printf '%s\n' "${VIDEOS[@]}" | sort) )

if (( ${#VIDEOS[@]} == 0 )); then
  echo "No videos found in $DIR"
  exit 1
fi

# Get current video index
if [[ -f "$STATE_FILE" ]]; then
  CURRENT=$(cat "$STATE_FILE")
else
  CURRENT=0
fi

# Find next video
NEXT=$(( (CURRENT + 1) % ${#VIDEOS[@]} ))

# Kill current mpvpaper
pkill -f "mpvpaper.*$MONITOR" 2>/dev/null || true
sleep 0.5

# Start next video
"$MPVPAPER_BIN" -f -o "no-audio loop" "$MONITOR" "${VIDEOS[$NEXT]}" >/dev/null 2>&1 &

# Save state
echo "$NEXT" > "$STATE_FILE"

echo "Playing: $(basename "${VIDEOS[$NEXT]}")"
