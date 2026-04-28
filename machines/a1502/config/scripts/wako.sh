#!/bin/bash
# Wako - Quote notifier

QUOTES_FILE="$HOME/.config/scripts/quotes.txt"
INTERVAL=2700  # 45 minutes

# Find D-Bus session from mako's environment
MAKO_PID=$(pgrep -x mako | head -1)
if [ -n "$MAKO_PID" ]; then
    export DBUS_SESSION_BUS_ADDRESS=$(cat /proc/$MAKO_PID/environ 2>/dev/null | tr '\0' '\n' | grep DBUS_SESSION_BUS_ADDRESS | cut -d= -f2-)
fi

# Fallback: try to find any dbus socket in /tmp
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    DBUS_SOCK=$(ls /tmp/dbus-* 2>/dev/null | head -1)
    if [ -n "$DBUS_SOCK" ]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_SOCK"
    fi
fi

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

# Wait for session to be ready
sleep 10

# Show one immediately
quote=$(shuf -n 1 "$QUOTES_FILE")
notify-send -a "Wako" -t 20000 "Wako" "$quote"

# Continue with intervals
while true; do
    sleep $INTERVAL
    quote=$(shuf -n 1 "$QUOTES_FILE")
    notify-send -a "Wako" -t 20000 "Wako" "$quote"
done
