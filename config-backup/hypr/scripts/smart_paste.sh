#!/bin/bash
# Get the class of the focused window
app=$(hyprctl activewindow -j | jq -r '.class')

# Check if it's a terminal
if echo "$app" | grep -qiE 'kitty|alacritty|gnome-terminal|konsole|wezterm'; then
    # Send Ctrl+Shift+V for terminals
    hyprctl dispatch sendshortcut "CTRL SHIFT, V,"
else
    # Send Ctrl+V for other apps
    hyprctl dispatch sendshortcut "CTRL, V,"
fi
