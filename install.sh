#!/bin/bash

# Nigel OS Installation Script
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Simple key mapping setup
setup_keys() {
    log_info "Setting up Super key as Cmd (macOS-like)..."
    
    # Create keymaps directory
    mkdir -p keymaps
    
    # Create simple XKB layout
    cat > keymaps/custom-xkb << 'XKBEOF'
default partial alphanumeric_keys
xkb_symbols "basic" {
    include "us"
    name[Group1]= "US with Control/Super swap";
    
    replace key <LCTL> { [ Super_L ] };
    replace key <LWIN> { [ Control_L ] };
    replace key <RCTL> { [ Super_R ] };
    replace key <RWIN> { [ Control_R ] };
    
    modifier_map Control { Super_L, Super_R };
    modifier_map Mod4    { Control_L, Control_R };
};
XKBEOF

    # Install the layout
    sudo cp keymaps/custom-xkb /usr/share/X11/xkb/symbols/custom
    sudo chmod 644 /usr/share/X11/xkb/symbols/custom
    
    # Apply it
    setxkbmap -layout custom -option
    
    # Make it persistent
    echo "setxkbmap -layout custom -option" >> ~/.xprofile
    
    log_success "Key mappings installed! Super key now works like Cmd"
}

main() {
    log_info "Starting Nigel OS setup..."
    setup_keys
    log_success "Setup complete! Log out and back in for full effect."
}

main "$@"
