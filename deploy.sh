#!/bin/bash

# NigelOS Deployment Script
# Deploys NigelOS configuration to new machines

set -e

echo "🚀 NigelOS Deployment Starting..."

# Get user information
USER_HOME="$HOME"
USERNAME="$(whoami)"

# Detect primary monitor
MONITOR="$(hyprctl monitors -j 2>/dev/null | jq -r '.[0].name' 2>/dev/null || echo "HDMI-A-1")"

echo "📋 Deployment Info:"
echo "  User: $USERNAME"
echo "  Home: $USER_HOME"
echo "  Monitor: $MONITOR"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p "$USER_HOME/.config"
mkdir -p "$USER_HOME/Pictures/Wallpapers"

# Function to process template files
process_template() {
    local src="$1"
    local dest="$2"

    echo "🔧 Processing: $src -> $dest"

    # Create destination directory if needed
    mkdir -p "$(dirname "$dest")"

    # Replace template variables
    sed -e "s|{{HOME}}|$USER_HOME|g" \
        -e "s|{{USER}}|$USERNAME|g" \
        -e "s|{{MONITOR}}|$MONITOR|g" \
        "$src" > "$dest"
}

# Deploy configuration files
echo "⚙️  Deploying configs..."

# Hyprland configs
process_template "config/hypr/hyprland.conf" "$USER_HOME/.config/hypr/hyprland.conf"
process_template "config/hypr/hyprpaper.conf" "$USER_HOME/.config/hypr/hyprpaper.conf"

# Waybar configs
process_template "config/waybar/config" "$USER_HOME/.config/waybar/config"
cp -r config/waybar/style.css "$USER_HOME/.config/waybar/" 2>/dev/null || true

# Kitty config
cp -r config/kitty/* "$USER_HOME/.config/kitty/" 2>/dev/null || true

# Rofi config
cp -r config/rofi/* "$USER_HOME/.config/rofi/" 2>/dev/null || true

# Make apps executable
echo "🔨 Setting up applications..."
find apps/ -name "*.sh" -exec chmod +x {} \;
find apps/ -name "*.py" -exec chmod +x {} \;
find apps/echo/scripts/ -type f -exec chmod +x {} \; 2>/dev/null || true

# Copy wallpaper collection
echo "🖼️  Copying wallpaper collection..."
cp -r wallpapers/* "$USER_HOME/Pictures/Wallpapers/" 2>/dev/null || {
    echo "⚠️  Note: Some wallpapers may already exist, skipping duplicates"
}

echo ""
echo "✅ NigelOS deployment complete!"
echo ""
echo "🔧 Next steps:"
echo "  1. Copy your wallpapers to ~/Pictures/Wallpapers/"
echo "  2. Restart Hyprland or reboot"
echo "  3. Check waybar and apps are working"
echo ""
echo "📱 Key bindings:"
echo "  Alt+I     - AI Chat"
echo "  Alt+Space - App launcher"
echo "  Alt+C/V   - Smart copy/paste"
echo ""