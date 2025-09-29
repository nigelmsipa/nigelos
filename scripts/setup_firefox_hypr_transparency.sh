#!/usr/bin/env bash
set -euo pipefail

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
MAIN_CONF="$CONF_DIR/hyprland.conf"
SNIPPET_DIR="$CONF_DIR/conf.d"
SNIPPET="$SNIPPET_DIR/firefox-transparency.conf"

mkdir -p "$SNIPPET_DIR"

# Backup main config once if it exists
if [[ -f "$MAIN_CONF" && ! -f "$MAIN_CONF.bak" ]]; then
  cp "$MAIN_CONF" "$MAIN_CONF.bak"
fi

# Ensure main config exists
if [[ ! -f "$MAIN_CONF" ]]; then
  printf "# Hyprland config\n" > "$MAIN_CONF"
fi

# Ensure conf.d is sourced (simple check)
if ! grep -q "conf.d/\\*.conf" "$MAIN_CONF"; then
  printf "\n# Include conf.d/*.conf snippets\nsource = ~/.config/hypr/conf.d/*.conf\n" >> "$MAIN_CONF"
fi

# Write Firefox transparency + blur snippet (idempotent overwrite)
cat > "$SNIPPET" <<'SNIP'
# Firefox transparency + blur (Hyprland)
# Run Firefox Wayland-native
env = MOZ_ENABLE_WAYLAND,1

# Enable and tune blur (safe defaults)
decoration {
  blur {
    enabled = true
    size = 8
    passes = 2
  }
}

# Opacity rules for Firefox windows (active 0.97, inactive 0.85)
windowrulev2 = opacity 0.97 0.85, class:^(firefox|Navigator)$

# Keep fullscreen and PiP readable
windowrulev2 = opacity 1.0 1.0, class:^(firefox|Navigator)$, fullscreen:1
windowrulev2 = opacity 1.0 1.0, class:^(firefox|Navigator)$, title:^(.*Picture-in-Picture.*)$
SNIP

chmod +x "$SNIPPET"

echo "Done."
echo "Snippet: $SNIPPET"
echo "Main config: $MAIN_CONF"

if command -v hyprctl >/dev/null 2>&1; then
  if hyprctl reload >/dev/null 2>&1; then
    echo "Hyprland reloaded. Restart Firefox to ensure Wayland + env are applied."
  else
    echo "Could not reload Hyprland automatically. Run: hyprctl reload"
  fi
else
  echo "hyprctl not found. Reload Hyprland manually to apply changes."
fi
