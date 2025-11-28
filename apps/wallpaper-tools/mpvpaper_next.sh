#!/bin/bash
# Video wallpaper switcher - manually cycle to next video
# Usage: ./mpvpaper_next.sh [--dir DIR] [--monitor MONITOR]

DIR="${HOME}/Downloads/mpvpaper"
MONITOR="HDMI-A-1"
MPVPAPER_BIN="${HOME}/.local/bin/mpvpaper"
STATE_FILE="${HOME}/.cache/mpvpaper_current"

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      DIR="$2"
      shift 2
      ;;
    --monitor)
      MONITOR="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--dir DIR] [--monitor MONITOR]"
      exit 0
      ;;
    *)
      shift
      ;;
  esac
done

mkdir -p "$(dirname "$STATE_FILE")"

# Get list of videos - try multiple patterns
shopt -s nullglob nocaseglob

VIDEOS=()
for ext in mp4 webm mkv avi mov MP4 WEBM MKV AVI MOV; do
  VIDEOS+=( "$DIR"/*."$ext" )
done

# Sort videos
VIDEOS=( $(printf '%s\n' "${VIDEOS[@]}" | sort -u) )

if [[ ${#VIDEOS[@]} -eq 0 ]]; then
  echo "No videos found in $DIR"
  exit 1
fi

# Get current video index
if [[ -f "$STATE_FILE" ]]; then
  CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
else
  CURRENT=0
fi

# Ensure CURRENT is a valid number
[[ ! "$CURRENT" =~ ^[0-9]+$ ]] && CURRENT=0

# Find next video
NEXT=$(( (CURRENT + 1) % ${#VIDEOS[@]} ))

# Kill current mpvpaper
pkill -9 mpvpaper 2>/dev/null || true
sleep 0.5

# Start next video
nohup "$MPVPAPER_BIN" -f -o "no-audio loop" "$MONITOR" "${VIDEOS[$NEXT]}" > /dev/null 2>&1 &

# Save state
echo "$NEXT" > "$STATE_FILE"

echo "Playing: $(basename "${VIDEOS[$NEXT]}")" | tee -a /tmp/mpvpaper.log
