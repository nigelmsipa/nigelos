#!/bin/bash
# Wrapper to launch wallpaper picker from rofi
# This script must fully detach from rofi to work properly

# Redirect all output to avoid blocking rofi
exec > /tmp/wallpaper_picker.log 2>&1

# Get environment - try to inherit from parent
DISPLAY=${DISPLAY:-:1}
WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}

# Export for child process
export DISPLAY
export WAYLAND_DISPLAY
export XDG_RUNTIME_DIR

# Log environment
echo "Launch time: $(date)"
echo "DISPLAY=$DISPLAY"
echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
echo ""

# Launch completely detached from rofi using setsid
setsid -f python3 /home/nigel/nigelos/apps/wallpaper-tools/wallpaper_setter.py

exit 0
