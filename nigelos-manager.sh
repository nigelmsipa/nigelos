#!/bin/bash

# NigelOS Manager - Master Control Script
# One script to rule them all

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_header() { echo -e "${PURPLE}[NIGELOS]${NC} $1"; }

# Banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════╗
    ║              NigelOS Manager          ║
    ║        Your Ultimate Setup Tool       ║
    ╚═══════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Quick status check
show_status() {
    log_header "NigelOS System Status"
    echo "======================"
    echo

    # Basic info
    echo "📋 System Info:"
    echo "  Host: $(hostname)"
    echo "  User: $(whoami)"
    echo "  Date: $(date)"
    echo

    # Quick health check
    echo "🔍 Quick Health Check:"

    # Hyprland
    if pgrep -x "Hyprland" > /dev/null; then
        echo "  ✅ Hyprland: Running"
    else
        echo "  ❌ Hyprland: Not running"
    fi

    # Waybar
    if pgrep -x "waybar" > /dev/null; then
        echo "  ✅ Waybar: Running"
    else
        echo "  ❌ Waybar: Not running"
    fi

    # Ollama
    if pgrep -f "ollama" > /dev/null; then
        echo "  ✅ Ollama: Running"
        if command -v ollama &> /dev/null; then
            local model_count=$(ollama list 2>/dev/null | wc -l)
            echo "     Models: $((model_count - 1))"
        fi
    else
        echo "  ⚠️  Ollama: Not running"
    fi

    # Git status
    if [ -d "$SCRIPT_DIR/.git" ]; then
        echo "  ✅ Git: $(git -C "$SCRIPT_DIR" rev-parse --short HEAD)"
        if [ -n "$(git -C "$SCRIPT_DIR" status --porcelain)" ]; then
            echo "     Status: Uncommitted changes"
        else
            echo "     Status: Clean"
        fi
    fi

    echo
}

# Backup and snapshot commands
backup_system() {
    log_header "Creating System Backup"

    log_info "Exporting packages..."
    "$SCRIPTS_DIR/package-manager.sh" export

    log_info "Backing up dotfiles..."
    "$SCRIPTS_DIR/dotfiles-manager.sh" backup

    log_info "Creating system snapshot..."
    "$SCRIPTS_DIR/system-snapshot.sh" create "backup-$(date +%Y%m%d_%H%M%S)"

    log_success "Complete system backup created!"
}

# Restore from backup
restore_system() {
    log_header "Restoring System from Backup"
    log_warning "This will restore packages and dotfiles from backup"

    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Cancelled"
        return
    fi

    log_info "Installing packages..."
    "$SCRIPTS_DIR/package-manager.sh" install

    log_info "Restoring dotfiles..."
    "$SCRIPTS_DIR/dotfiles-manager.sh" restore

    log_success "System restoration complete!"
    log_info "Consider running: $0 validate"
}

# Sync with git
sync_repo() {
    log_header "Syncing NigelOS Repository"

    if [ ! -d "$SCRIPT_DIR/.git" ]; then
        log_error "Not a git repository. Initialize with: git init"
        return 1
    fi

    # Check for uncommitted changes
    if [ -n "$(git -C "$SCRIPT_DIR" status --porcelain)" ]; then
        log_info "Uncommitted changes detected"

        read -p "Commit current state? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create backup first
            backup_system

            # Commit changes
            git -C "$SCRIPT_DIR" add .
            git -C "$SCRIPT_DIR" commit -m "Sync: $(date)"
            log_success "Changes committed"
        fi
    fi

    # Pull latest changes
    if git -C "$SCRIPT_DIR" remote | grep -q origin; then
        log_info "Pulling latest changes..."
        git -C "$SCRIPT_DIR" pull

        log_info "Pushing local changes..."
        git -C "$SCRIPT_DIR" push

        log_success "Repository synced!"
    else
        log_warning "No remote origin configured"
        log_info "Add remote with: git remote add origin <your-repo-url>"
    fi
}

# Migration workflow
prepare_migration() {
    log_header "Preparing for Migration"

    local snapshot_name="migration-ready-$(date +%Y%m%d_%H%M%S)"

    log_info "Creating migration snapshot..."
    backup_system

    log_info "Creating export package..."
    "$SCRIPTS_DIR/system-snapshot.sh" export "$snapshot_name"

    log_success "Migration package ready!"
    log_info "Transfer file: ~/nigelos-snapshot-${snapshot_name}.tar.gz"
    echo
    log_info "On new system run:"
    echo "  tar -xzf nigelos-snapshot-*.tar.gz"
    echo "  cd nigelos"
    echo "  ./nigelos-manager.sh setup-new-system"
}

# Setup on new system
setup_new_system() {
    log_header "Setting up NigelOS on New System"

    log_info "Deploying base configuration..."
    ./deploy.sh

    log_info "Installing packages..."
    "$SCRIPTS_DIR/package-manager.sh" install

    log_info "Restoring dotfiles..."
    "$SCRIPTS_DIR/dotfiles-manager.sh" restore

    log_info "Running validation..."
    "$SCRIPTS_DIR/setup-validator.sh" full

    log_success "New system setup complete!"
    log_info "Reboot or restart Hyprland to complete setup"
}

# Update system
update_system() {
    log_header "Updating NigelOS System"

    # Update packages
    log_info "Updating system packages..."
    sudo pacman -Syu

    if command -v yay &> /dev/null; then
        log_info "Updating AUR packages..."
        yay -Syu
    fi

    # Update git repo
    sync_repo

    # Validate after update
    log_info "Validating system..."
    "$SCRIPTS_DIR/setup-validator.sh" quick

    log_success "System update complete!"
}

# Install AI models
setup_ai() {
    log_header "Setting up AI Models"

    if ! command -v ollama &> /dev/null; then
        log_error "Ollama not found. Install with: yay -S ollama"
        return 1
    fi

    # Start ollama service
    if ! pgrep -f "ollama" > /dev/null; then
        log_info "Starting Ollama service..."
        systemctl --user start ollama || sudo systemctl start ollama
    fi

    # Install recommended models
    log_info "Installing Phi3 model (speed)..."
    ollama pull phi3

    log_info "Installing Qwen2 model (accuracy)..."
    ollama pull qwen2

    log_success "AI models installed!"
    log_info "Test with Alt+I keybinding"
}

# Developer setup
setup_dev() {
    log_header "Setting up Development Environment"

    # Common dev tools
    log_info "Installing development packages..."
    yay -S --needed base-devel git vim neovim \
        nodejs npm python python-pip \
        docker docker-compose \
        code

    # Setup directories
    log_info "Creating development directories..."
    mkdir -p ~/Projects ~/Scripts ~/bin

    # Git configuration reminder
    log_warning "Don't forget to configure git:"
    echo "  git config --global user.name 'Your Name'"
    echo "  git config --global user.email 'your.email@example.com'"

    log_success "Development environment ready!"
}

# Show main menu
show_menu() {
    show_banner
    echo "Available Commands:"
    echo
    echo "📊 Status & Info:"
    echo "  status          - Show system status"
    echo "  validate        - Run full system validation"
    echo "  quick-check     - Quick health check"
    echo
    echo "💾 Backup & Restore:"
    echo "  backup          - Create complete system backup"
    echo "  restore         - Restore from backup"
    echo "  snapshot        - Create system snapshot"
    echo
    echo "🔄 Migration:"
    echo "  prepare         - Prepare for migration"
    echo "  setup-new       - Setup on new system"
    echo "  sync            - Sync with git repository"
    echo
    echo "⚙️ System Management:"
    echo "  update          - Update entire system"
    echo "  deploy          - Deploy/redeploy configs"
    echo
    echo "🧠 AI & Development:"
    echo "  setup-ai        - Install AI models"
    echo "  setup-dev       - Setup development environment"
    echo
    echo "📚 Help:"
    echo "  help            - Show this menu"
    echo "  docs            - Show documentation links"
    echo
    echo "Usage: $0 <command>"
}

# Show documentation
show_docs() {
    log_header "NigelOS Documentation"
    echo
    echo "📚 Available Documentation:"
    echo "  README.md          - Main overview"
    echo "  PREFERENCES.md     - User preferences"
    echo "  docs/MIGRATION_GUIDE.md - Complete migration guide"
    echo
    echo "🔧 Script Documentation:"
    echo "  scripts/package-manager.sh help"
    echo "  scripts/dotfiles-manager.sh help"
    echo "  scripts/system-snapshot.sh help"
    echo "  scripts/setup-validator.sh help"
    echo
    echo "🌐 Online:"
    echo "  GitHub: https://github.com/nigelmsipa/nigelos"
}

# Main logic
case "${1:-help}" in
    status)
        show_status
        ;;
    validate)
        "$SCRIPTS_DIR/setup-validator.sh" full
        ;;
    quick-check)
        "$SCRIPTS_DIR/setup-validator.sh" quick
        ;;
    backup)
        backup_system
        ;;
    restore)
        restore_system
        ;;
    snapshot)
        "$SCRIPTS_DIR/system-snapshot.sh" create "${2:-manual-$(date +%Y%m%d_%H%M%S)}"
        ;;
    prepare)
        prepare_migration
        ;;
    setup-new)
        setup_new_system
        ;;
    sync)
        sync_repo
        ;;
    update)
        update_system
        ;;
    deploy)
        ./deploy.sh
        ;;
    setup-ai)
        setup_ai
        ;;
    setup-dev)
        setup_dev
        ;;
    docs)
        show_docs
        ;;
    help|--help|-h)
        show_menu
        ;;
    *)
        show_menu
        ;;
esac