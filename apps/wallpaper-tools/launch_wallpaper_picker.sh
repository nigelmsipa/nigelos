#!/bin/bash
# Wrapper to launch wallpaper picker from rofi with proper environment

export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Launch the Python GUI in the background, detached from rofi
nohup python3 /home/nigel/nigelos/apps/wallpaper-tools/wallpaper_setter.py > /dev/null 2>&1 &

exit 0
