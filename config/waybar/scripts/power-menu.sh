#!/bin/bash
choice=$(echo -e "⏻ Shutdown\n Restart\n󰍃 Logout\n󰒲 Sleep" | rofi -dmenu -i -p "Power Menu" || echo -e "⏻ Shutdown\n Restart\n󰍃 Logout\n󰒲 Sleep" | wofi --dmenu)

case "$choice" in
    *"Shutdown") shutdown now ;;
    *"Restart") reboot ;;
    *"Logout") hyprctl dispatch exit ;;
    *"Sleep") systemctl suspend ;;
esac
