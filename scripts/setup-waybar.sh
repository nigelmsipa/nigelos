#!/bin/bash

# Waybar Catppuccin Setup Script - Complete Installation
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Create waybar config directory
setup_waybar_directory() {
    log_info "Setting up waybar configuration directory..."
    mkdir -p ~/.config/waybar
    log_success "Waybar directory created"
}

# Backup existing config
backup_existing() {
    if [ -f ~/.config/waybar/config ]; then
        log_warning "Backing up existing waybar config..."
        cp ~/.config/waybar/config ~/.config/waybar/config.backup.$(date +%Y%m%d_%H%M%S)
        log_success "Config backup created"
    fi
    
    if [ -f ~/.config/waybar/style.css ]; then
        log_warning "Backing up existing waybar style..."
        cp ~/.config/waybar/style.css ~/.config/waybar/style.css.backup.$(date +%Y%m%d_%H%M%S)
        log_success "Style backup created"
    fi
}

# Install waybar config
install_waybar_config() {
    log_info "Installing waybar configuration..."
    
    cat > ~/.config/waybar/config << 'CONFIGEOF'
{
    "layer": "top",
    "position": "top",
    "height": 40,
    "spacing": 10,
    "margin-top": 10,
    "margin-left": 10,
    "margin-right": 10,
    
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery"],

    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}",
        "format-icons": {
            "urgent": "",
            "focused": "",
            "default": ""
        }
    },

    "clock": {
        "timezone": "America/New_York",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format": "{:%H:%M}",
        "format-alt": "{:%Y-%m-%d}"
    },

    "cpu": {
        "format": "󰻠 {usage}%",
        "tooltip": false,
        "interval": 2
    },

    "memory": {
        "format": "󰍛 {}%",
        "tooltip-format": "{used:0.1f}G/{total:0.1f}G used"
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-plugged": " {capacity}%",
        "format-alt": "{icon} {time}",
        "format-icons": ["", "", "", "", ""]
    },

    "network": {
        "format-wifi": " {signalStrength}%",
        "format-ethernet": " {ipaddr}/{cidr}",
        "tooltip-format": "{ifname} via {gwaddr}",
        "format-linked": " {ifname} (No IP)",
        "format-disconnected": "⚠ Disconnected",
        "format-alt": "{ifname}: {ipaddr}/{cidr}",
        "interval": 2
    },

    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-bluetooth": "{icon} {volume}%",
        "format-bluetooth-muted": " {icon}",
        "format-muted": "",
        "format-source": " {volume}%",
        "format-source-muted": "",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    }
}
CONFIGEOF
    
    log_success "Waybar config installed"
}

# Install waybar style
install_waybar_style() {
    log_info "Installing waybar style..."
    
    cat > ~/.config/waybar/style.css << 'STYLEEOF'
/* Catppuccin Mocha Color Definitions */
@define-color rosewater #f5e0dc;
@define-color flamingo #f2cdcd;
@define-color pink #f5c2e7;
@define-color mauve #cba6f7;
@define-color red #f38ba8;
@define-color maroon #eba0ac;
@define-color peach #fab387;
@define-color yellow #f9e2af;
@define-color green #a6e3a1;
@define-color teal #94e2d5;
@define-color sky #89dceb;
@define-color sapphire #74c7ec;
@define-color blue #89b4fa;
@define-color lavender #b4befe;
@define-color text #cdd6f4;
@define-color subtext1 #bac2de;
@define-color subtext0 #a6adc8;
@define-color overlay2 #9399b2;
@define-color overlay1 #7f849c;
@define-color overlay0 #6c7086;
@define-color surface2 #585b70;
@define-color surface1 #45475a;
@define-color surface0 #313244;
@define-color base #1e1e2e;
@define-color mantle #181825;
@define-color crust #11111b;

* {
  font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
  font-size: 18px;
}

window#waybar {
  background-color: rgba(0, 0, 0, 0);
  border-radius: 13px;
  transition-property: background-color;
  transition-duration: 0.5s;
}

button {
  box-shadow: inset 0 -3px transparent;
  border: none;
  border-radius: 0;
}

button:hover {
  background: inherit;
  box-shadow: inset 0 -3px #ffffff;
}

#workspaces button {
  padding: 0 5px;
  background-color: transparent;
  color: #ffffff;
}

#workspaces button:hover {
  background: rgba(0, 0, 0, 0.2);
}

#workspaces button.focused {
  background-color: @lavender;
  box-shadow: inset 0 -3px #ffffff;
}

#workspaces button.urgent {
  background-color: #eb4d4b;
}

#mode {
  background-color: #64727d;
  box-shadow: inset 0 -3px #ffffff;
}

#clock,
#battery,
#cpu,
#memory,
#temperature,
#network,
#pulseaudio {
  padding: 0 10px;
  color: @text;
  border: 5px;
}

.modules-right,
.modules-left,
.modules-center {
  background-color: @base;
  border-radius: 15px;
}

.modules-right {
  padding: 0 10px;
}

.modules-left {
  padding: 0 20px;
}

.modules-center {
  padding: 0 10px;
}

#battery.charging,
#battery.plugged {
  color: @sapphire;
}

@keyframes blink {
  to {
    color: #000000;
  }
}

#battery.critical:not(.charging) {
  background-color: #f53c3c;
  color: #ffffff;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: steps(12);
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

label:focus {
  background-color: #000000;
}

#pulseaudio.muted {
  color: @text;
}
STYLEEOF
    
    log_success "Waybar style installed"
}

# Install required fonts
install_fonts() {
    log_info "Checking for required fonts..."
    
    if ! fc-list | grep -i "JetBrainsMono Nerd Font" > /dev/null; then
        log_warning "JetBrainsMono Nerd Font not found. Installing..."
        
        # Try different package managers
        if command -v yay &> /dev/null; then
            yay -S --noconfirm ttf-jetbrains-mono-nerd
        elif command -v paru &> /dev/null; then
            paru -S --noconfirm ttf-jetbrains-mono-nerd
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
        else
            log_warning "Could not auto-install font. Please install JetBrainsMono Nerd Font manually."
            echo "Download from: https://www.nerdfonts.com/font-downloads"
            return
        fi
        
        log_success "JetBrainsMono Nerd Font installed"
    else
        log_success "JetBrainsMono Nerd Font found"
    fi
}

# Restart waybar
restart_waybar() {
    log_info "Restarting waybar..."
    pkill waybar 2>/dev/null || true
    sleep 1
    waybar &
    log_success "Waybar restarted with new configuration"
}

main() {
    echo "Setting up Catppuccin Waybar configuration..."
    echo "============================================="
    echo
    
    setup_waybar_directory
    backup_existing
    install_fonts
    install_waybar_config
    install_waybar_style
    restart_waybar
    
    echo
    log_success "Setup complete!"
    echo "Your waybar now has the beautiful Catppuccin theme!"
    echo "If you need to restart waybar: pkill waybar && waybar &"
}

main "$@"
