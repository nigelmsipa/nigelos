#!/bin/bash

# NigelOS Package Manager
# Handles system package backup, restoration, and synchronization

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIGELOS_ROOT="$(dirname "$SCRIPT_DIR")"
PACKAGES_DIR="$NIGELOS_ROOT/packages"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Create packages directory structure
init_package_system() {
    log_info "Initializing package system..."
    mkdir -p "$PACKAGES_DIR"/{arch,aur,flatpak,python,npm,cargo,snap}
    touch "$PACKAGES_DIR"/.nigelos-packages
    log_success "Package system initialized"
}

# Export current system packages
export_packages() {
    log_info "Exporting current system packages..."

    # Arch Linux packages
    if command -v pacman &> /dev/null; then
        log_info "Exporting Arch packages..."
        pacman -Qqe > "$PACKAGES_DIR/arch/explicit-packages.txt"
        pacman -Qqd > "$PACKAGES_DIR/arch/dependency-packages.txt"
        pacman -Qqm > "$PACKAGES_DIR/arch/foreign-packages.txt"
    fi

    # AUR packages
    if command -v yay &> /dev/null; then
        log_info "Exporting AUR packages..."
        yay -Qqm > "$PACKAGES_DIR/aur/aur-packages.txt"
    fi

    # Flatpak applications
    if command -v flatpak &> /dev/null; then
        log_info "Exporting Flatpak apps..."
        flatpak list --app --columns=application > "$PACKAGES_DIR/flatpak/flatpak-apps.txt"
    fi

    # Python packages
    if command -v pip &> /dev/null; then
        log_info "Exporting Python packages..."
        pip freeze > "$PACKAGES_DIR/python/pip-packages.txt"
    fi

    # Global npm packages
    if command -v npm &> /dev/null; then
        log_info "Exporting npm packages..."
        npm list -g --depth=0 --json > "$PACKAGES_DIR/npm/global-packages.json"
        npm list -g --depth=0 --parseable | tail -n +2 | awk -F/ '{print $NF}' > "$PACKAGES_DIR/npm/global-packages.txt"
    fi

    # Cargo packages
    if command -v cargo &> /dev/null && [ -f ~/.cargo/.crates.toml ]; then
        log_info "Exporting Cargo packages..."
        cargo install --list | grep -E "^[a-zA-Z0-9_-]+ v[0-9]" | awk '{print $1}' > "$PACKAGES_DIR/cargo/cargo-packages.txt"
    fi

    # Snap packages
    if command -v snap &> /dev/null; then
        log_info "Exporting Snap packages..."
        snap list | tail -n +2 | awk '{print $1}' > "$PACKAGES_DIR/snap/snap-packages.txt"
    fi

    # Generate timestamp
    date "+%Y-%m-%d %H:%M:%S" > "$PACKAGES_DIR/last-export.txt"

    log_success "Package export complete! Files saved to: $PACKAGES_DIR"
}

# Install packages from exported lists
install_packages() {
    log_info "Installing packages from NigelOS package lists..."

    # Arch packages
    if [ -f "$PACKAGES_DIR/arch/explicit-packages.txt" ] && command -v pacman &> /dev/null; then
        log_info "Installing Arch packages..."
        sudo pacman -S --needed --noconfirm $(cat "$PACKAGES_DIR/arch/explicit-packages.txt")
    fi

    # AUR packages
    if [ -f "$PACKAGES_DIR/aur/aur-packages.txt" ] && command -v yay &> /dev/null; then
        log_info "Installing AUR packages..."
        yay -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur/aur-packages.txt")
    fi

    # Flatpak apps
    if [ -f "$PACKAGES_DIR/flatpak/flatpak-apps.txt" ] && command -v flatpak &> /dev/null; then
        log_info "Installing Flatpak apps..."
        while read -r app; do
            [ -n "$app" ] && flatpak install -y "$app"
        done < "$PACKAGES_DIR/flatpak/flatpak-apps.txt"
    fi

    # Python packages
    if [ -f "$PACKAGES_DIR/python/pip-packages.txt" ] && command -v pip &> /dev/null; then
        log_info "Installing Python packages..."
        pip install -r "$PACKAGES_DIR/python/pip-packages.txt"
    fi

    # Global npm packages
    if [ -f "$PACKAGES_DIR/npm/global-packages.txt" ] && command -v npm &> /dev/null; then
        log_info "Installing global npm packages..."
        while read -r package; do
            [ -n "$package" ] && npm install -g "$package"
        done < "$PACKAGES_DIR/npm/global-packages.txt"
    fi

    # Cargo packages
    if [ -f "$PACKAGES_DIR/cargo/cargo-packages.txt" ] && command -v cargo &> /dev/null; then
        log_info "Installing Cargo packages..."
        while read -r package; do
            [ -n "$package" ] && cargo install "$package"
        done < "$PACKAGES_DIR/cargo/cargo-packages.txt"
    fi

    log_success "Package installation complete!"
}

# Show package statistics
show_stats() {
    log_info "NigelOS Package Statistics:"
    echo

    for pkg_type in arch aur flatpak python npm cargo snap; do
        case $pkg_type in
            arch)
                if [ -f "$PACKAGES_DIR/arch/explicit-packages.txt" ]; then
                    count=$(wc -l < "$PACKAGES_DIR/arch/explicit-packages.txt")
                    echo "  📦 Arch packages: $count"
                fi
                ;;
            aur)
                if [ -f "$PACKAGES_DIR/aur/aur-packages.txt" ]; then
                    count=$(wc -l < "$PACKAGES_DIR/aur/aur-packages.txt")
                    echo "  🔧 AUR packages: $count"
                fi
                ;;
            flatpak)
                if [ -f "$PACKAGES_DIR/flatpak/flatpak-apps.txt" ]; then
                    count=$(wc -l < "$PACKAGES_DIR/flatpak/flatpak-apps.txt")
                    echo "  📱 Flatpak apps: $count"
                fi
                ;;
            python)
                if [ -f "$PACKAGES_DIR/python/pip-packages.txt" ]; then
                    count=$(wc -l < "$PACKAGES_DIR/python/pip-packages.txt")
                    echo "  🐍 Python packages: $count"
                fi
                ;;
            npm)
                if [ -f "$PACKAGES_DIR/npm/global-packages.txt" ]; then
                    count=$(wc -l < "$PACKAGES_DIR/npm/global-packages.txt")
                    echo "  📦 npm packages: $count"
                fi
                ;;
            cargo)
                if [ -f "$PACKAGES_DIR/cargo/cargo-packages.txt" ]; then
                    count=$(wc -l < "$PACKAGES_DIR/cargo/cargo-packages.txt")
                    echo "  🦀 Cargo packages: $count"
                fi
                ;;
        esac
    done

    echo
    if [ -f "$PACKAGES_DIR/last-export.txt" ]; then
        echo "  📅 Last export: $(cat "$PACKAGES_DIR/last-export.txt")"
    fi
}

# Main menu
show_help() {
    echo "NigelOS Package Manager"
    echo "======================="
    echo
    echo "Commands:"
    echo "  init     - Initialize package system"
    echo "  export   - Export current system packages"
    echo "  install  - Install packages from saved lists"
    echo "  stats    - Show package statistics"
    echo "  help     - Show this help"
    echo
    echo "Usage: $0 <command>"
}

# Main logic
case "${1:-}" in
    init)
        init_package_system
        ;;
    export)
        init_package_system
        export_packages
        ;;
    install)
        install_packages
        ;;
    stats)
        show_stats
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac