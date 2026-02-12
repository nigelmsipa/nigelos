#!/bin/bash
# Get the focused window app-id from niri
app=$(niri msg focused-window 2>/dev/null | grep -oP 'app_id: "\K[^"]+')

# Check if it's a terminal
if echo "$app" | grep -qiE 'Alacritty|kitty|foot|wezterm|gnome-terminal|konsole|com.mitchellh.ghostty'; then
    # Send Ctrl+Shift+C for terminals
    wtype -M ctrl -M shift -k c
else
    # Send Ctrl+C for other apps
    wtype -M ctrl -k c
fi
