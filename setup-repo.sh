#!/bin/bash

# Nigel OS Repository Structure Setup
# Run this to create the proper directory structure for your dotfiles repo

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Create directory structure
create_directories() {
    log_info "Creating directory structure..."
    
    mkdir -p {config,scripts,keymaps,assets/wallpapers}
    mkdir -p config/{hypr,waybar,alacritty,rofi,gtk,nvim}
    
    log_success "Directory structure created"
}

main() {
    echo "Setting up Nigel OS repository structure..."
    create_directories
    echo
    log_success "Basic structure created! Now create the other files."
}

main "$@"
