#!/bin/bash
# Clean, simple wallpaper picker for rofi with proper environment handling

set -euo pipefail

# Directories
IMAGE_DIR="$HOME/Pictures/Wallpapers"
VIDEO_DIR="$HOME/Downloads/mpvpaper"

# Function to get current Hyprland environment
get_hypr_env() {
    local hypr_pid=$(pgrep -u "$(id -u)" "^Hyprland$" | head -1)

    if [[ -n "$hypr_pid" ]]; then
        eval "$(cat /proc/"$hypr_pid"/environ | tr '\0' '\n' | grep -E '^(DISPLAY|WAYLAND_DISPLAY|XDG_RUNTIME_DIR|HYPRLAND_INSTANCE_SIGNATURE)=')"
    fi

    # Fallback defaults
    export DISPLAY="${DISPLAY:-:1}"
    export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
}

# Function to get all wallpapers with type indicator
get_wallpaper_list() {
    local items=()

    # Get images
    if [[ -d "$IMAGE_DIR" ]]; then
        while IFS= read -r file; do
            local name=$(basename "$file")
            items+=("🖼️  $name")
        done < <(find "$IMAGE_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) | sort)
    fi

    # Get videos
    if [[ -d "$VIDEO_DIR" ]]; then
        while IFS= read -r file; do
            local name=$(basename "$file")
            items+=("🎬 $name")
        done < <(find "$VIDEO_DIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" \) | sort)
    fi

    printf '%s\n' "${items[@]}"
}

# Function to extract filename from display name
extract_filename() {
    # Remove emoji and extra spaces from the beginning
    echo "$1" | sed 's/^.* \+//'
}

# Function to get file type
get_file_type() {
    local filename="$1"
    local file_path=""

    # Check if it's an image
    if [[ -f "$IMAGE_DIR/$filename" ]]; then
        echo "image"
        return 0
    fi

    # Check if it's a video
    if [[ -f "$VIDEO_DIR/$filename" ]]; then
        echo "video"
        return 0
    fi

    return 1
}

# Function to get full file path
get_file_path() {
    local filename="$1"

    if [[ -f "$IMAGE_DIR/$filename" ]]; then
        echo "$IMAGE_DIR/$filename"
    elif [[ -f "$VIDEO_DIR/$filename" ]]; then
        echo "$VIDEO_DIR/$filename"
    fi
}

# Function to set wallpaper
set_wallpaper() {
    local filename="$1"
    local type=$(get_file_type "$filename")
    local file_path=$(get_file_path "$filename")

    if [[ -z "$file_path" ]]; then
        notify-send "Error" "Wallpaper not found: $filename"
        return 1
    fi

    case "$type" in
        image)
            swww-daemon 2>/dev/null || true
            sleep 0.5
            swww img "$file_path" 2>/dev/null
            notify-send "Wallpaper set" "$filename"
            ;;
        video)
            pkill -9 mpvpaper 2>/dev/null || true
            sleep 0.5
            ~/.local/bin/mpvpaper -f -o "no-audio loop" HDMI-A-1 "$file_path" > /dev/null 2>&1 &
            notify-send "Video wallpaper set" "$filename"
            ;;
    esac
}

# Ensure Hyprland environment is set
get_hypr_env

# Show rofi menu
SELECTED=$(get_wallpaper_list | rofi -dmenu -p "Wallpaper: " -theme-str 'window {width: 800px;}')

if [[ -z "$SELECTED" ]]; then
    exit 0
fi

# Extract filename and set wallpaper
FILENAME=$(extract_filename "$SELECTED")
set_wallpaper "$FILENAME"
