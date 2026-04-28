#!/bin/bash

# NigelOS Dotfiles Manager
# Handles backup, sync, and restoration of dotfiles and configurations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIGELOS_ROOT="$(dirname "$SCRIPT_DIR")"
DOTFILES_DIR="$NIGELOS_ROOT/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Critical dotfiles and configs to track
DOTFILES_LIST=(
    ".bashrc"
    ".bash_profile"
    ".zprofile"
    ".gitconfig"
    ".xinitrc"
    ".xprofile"
    ".gtkrc-2.0"
    ".profile"
)

CONFIG_DIRS=(
    ".config/hypr"
    ".config/waybar"
    ".config/kitty"
    ".config/rofi"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/fontconfig"
    ".config/mimeapps.list"
    ".config/user-dirs.dirs"
    ".ssh/config"
    ".gnupg/gpg.conf"
)

SPECIAL_FILES=(
    ".local/share/applications"
    ".local/share/keyrings"
)

# Initialize dotfiles system
init_dotfiles() {
    log_info "Initializing dotfiles management system..."
    mkdir -p "$DOTFILES_DIR"/{home,config,special,scripts}
    touch "$DOTFILES_DIR/.nigelos-dotfiles"

    # Create gitignore for sensitive files
    cat > "$DOTFILES_DIR/.gitignore" << 'EOF'
# Sensitive files
**/*_rsa
**/*_rsa.pub
**/*_ed25519
**/*_ed25519.pub
**/id_*
**/known_hosts
**/*.key
**/*.pem
**/*.p12
**/*.keystore
**/passwd
**/shadow
**/gshadow
**/*password*
**/*secret*
**/wallet.dat
**/*.wallet
**/cookies.sqlite*
**/signons.sqlite
**/key4.db
**/logins.json
**/.env
**/credentials.*
EOF

    log_success "Dotfiles system initialized"
}

# Backup current dotfiles
backup_dotfiles() {
    log_info "Backing up current dotfiles..."

    # Backup individual dotfiles
    log_info "Backing up home dotfiles..."
    for file in "${DOTFILES_LIST[@]}"; do
        if [ -f "$HOME/$file" ]; then
            cp "$HOME/$file" "$DOTFILES_DIR/home/"
            log_info "  ✓ Backed up $file"
        fi
    done

    # Backup config directories
    log_info "Backing up config directories..."
    for dir in "${CONFIG_DIRS[@]}"; do
        if [ -d "$HOME/$dir" ]; then
            mkdir -p "$DOTFILES_DIR/config/$(dirname "$dir")"
            cp -r "$HOME/$dir" "$DOTFILES_DIR/config/$dir"
            log_info "  ✓ Backed up $dir"
        elif [ -f "$HOME/$dir" ]; then
            mkdir -p "$DOTFILES_DIR/config/$(dirname "$dir")"
            cp "$HOME/$dir" "$DOTFILES_DIR/config/$dir"
            log_info "  ✓ Backed up $dir (file)"
        fi
    done

    # Backup special directories (with filtering)
    log_info "Backing up special directories..."
    for item in "${SPECIAL_FILES[@]}"; do
        if [ -d "$HOME/$item" ]; then
            mkdir -p "$DOTFILES_DIR/special/$(dirname "$item")"

            # Filter out sensitive files for .local/share/keyrings
            if [[ "$item" == *"keyrings"* ]]; then
                # Only backup keyring structure, not actual keys
                find "$HOME/$item" -name "*.keyring" -exec basename {} \; > "$DOTFILES_DIR/special/$item-list.txt" 2>/dev/null || true
                log_info "  ✓ Backed up $item structure"
            else
                cp -r "$HOME/$item" "$DOTFILES_DIR/special/$item"
                log_info "  ✓ Backed up $item"
            fi
        fi
    done

    # Create backup manifest
    cat > "$DOTFILES_DIR/backup-manifest.txt" << EOF
NigelOS Dotfiles Backup
======================
Date: $(date)
User: $(whoami)
Host: $(hostname)
System: $(uname -a)

Backed up files:
$(find "$DOTFILES_DIR" -type f | wc -l) files total

Home dotfiles: ${#DOTFILES_LIST[@]} items
Config directories: ${#CONFIG_DIRS[@]} items
Special directories: ${#SPECIAL_FILES[@]} items
EOF

    log_success "Dotfiles backup complete! Saved to: $DOTFILES_DIR"
}

# Restore dotfiles to system
restore_dotfiles() {
    log_info "Restoring dotfiles to system..."

    # Create backup of current files
    BACKUP_DIR="$HOME/.nigelos-restore-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    log_info "Creating backup of current files in: $BACKUP_DIR"

    # Restore home dotfiles
    log_info "Restoring home dotfiles..."
    for file in $(ls "$DOTFILES_DIR/home/" 2>/dev/null || true); do
        if [ -f "$HOME/$file" ]; then
            cp "$HOME/$file" "$BACKUP_DIR/"
        fi
        cp "$DOTFILES_DIR/home/$file" "$HOME/"
        log_info "  ✓ Restored $file"
    done

    # Restore config directories
    log_info "Restoring config directories..."
    if [ -d "$DOTFILES_DIR/config" ]; then
        # Create .config if it doesn't exist
        mkdir -p "$HOME/.config"

        # Copy all config files/directories
        find "$DOTFILES_DIR/config" -mindepth 1 -type d -exec mkdir -p "$HOME/{}" \; 2>/dev/null || true
        find "$DOTFILES_DIR/config" -type f -exec cp {} "$HOME/{}" \; 2>/dev/null || true

        log_info "  ✓ Restored config directories"
    fi

    # Restore special directories
    log_info "Restoring special directories..."
    if [ -d "$DOTFILES_DIR/special" ]; then
        find "$DOTFILES_DIR/special" -mindepth 1 -type d -exec mkdir -p "$HOME/{}" \; 2>/dev/null || true
        find "$DOTFILES_DIR/special" -type f -not -name "*-list.txt" -exec cp {} "$HOME/{}" \; 2>/dev/null || true

        log_info "  ✓ Restored special directories"
    fi

    log_success "Dotfiles restoration complete!"
    log_info "Previous files backed up to: $BACKUP_DIR"
}

# Show sync status
show_status() {
    log_info "NigelOS Dotfiles Status:"
    echo

    if [ -f "$DOTFILES_DIR/backup-manifest.txt" ]; then
        echo "📋 Last Backup Info:"
        grep -E "(Date|User|Host)" "$DOTFILES_DIR/backup-manifest.txt" | sed 's/^/  /'
        echo
    fi

    echo "📁 Tracked Items:"

    # Count backed up files
    if [ -d "$DOTFILES_DIR/home" ]; then
        home_count=$(ls -1 "$DOTFILES_DIR/home" 2>/dev/null | wc -l)
        echo "  🏠 Home dotfiles: $home_count files"
    fi

    if [ -d "$DOTFILES_DIR/config" ]; then
        config_count=$(find "$DOTFILES_DIR/config" -type f 2>/dev/null | wc -l)
        echo "  ⚙️  Config files: $config_count files"
    fi

    if [ -d "$DOTFILES_DIR/special" ]; then
        special_count=$(find "$DOTFILES_DIR/special" -type f 2>/dev/null | wc -l)
        echo "  📦 Special files: $special_count files"
    fi

    echo

    # Check for differences
    echo "🔍 System vs Backup Differences:"
    differences_found=false

    for file in "${DOTFILES_LIST[@]}"; do
        if [ -f "$HOME/$file" ] && [ -f "$DOTFILES_DIR/home/$file" ]; then
            if ! diff -q "$HOME/$file" "$DOTFILES_DIR/home/$file" >/dev/null 2>&1; then
                echo "  ⚠️  $file has changed"
                differences_found=true
            fi
        fi
    done

    if [ "$differences_found" = false ]; then
        echo "  ✅ No differences detected"
    fi
}

# Create symlinks instead of copies (for advanced users)
symlink_dotfiles() {
    log_warning "Creating symlinks to NigelOS dotfiles..."
    log_warning "This will replace your current dotfiles with symlinks!"

    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Cancelled"
        return
    fi

    # Backup existing files
    BACKUP_DIR="$HOME/.nigelos-symlink-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    # Symlink home dotfiles
    for file in $(ls "$DOTFILES_DIR/home/" 2>/dev/null || true); do
        if [ -f "$HOME/$file" ]; then
            mv "$HOME/$file" "$BACKUP_DIR/"
        fi
        ln -sf "$DOTFILES_DIR/home/$file" "$HOME/$file"
        log_info "  ✓ Symlinked $file"
    done

    log_success "Symlinks created! Original files backed up to: $BACKUP_DIR"
    log_warning "Remember to commit changes in $DOTFILES_DIR to sync across systems"
}

# Main help
show_help() {
    echo "NigelOS Dotfiles Manager"
    echo "========================"
    echo
    echo "Commands:"
    echo "  init     - Initialize dotfiles system"
    echo "  backup   - Backup current dotfiles"
    echo "  restore  - Restore dotfiles to system"
    echo "  status   - Show sync status and differences"
    echo "  symlink  - Create symlinks (advanced)"
    echo "  help     - Show this help"
    echo
    echo "Usage: $0 <command>"
}

# Main logic
case "${1:-}" in
    init)
        init_dotfiles
        ;;
    backup)
        init_dotfiles
        backup_dotfiles
        ;;
    restore)
        restore_dotfiles
        ;;
    status)
        show_status
        ;;
    symlink)
        symlink_dotfiles
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac