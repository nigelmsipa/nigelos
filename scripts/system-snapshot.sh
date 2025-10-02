#!/bin/bash

# NigelOS System Snapshot Manager
# Creates comprehensive system snapshots for easy migration and restoration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIGELOS_ROOT="$(dirname "$SCRIPT_DIR")"
SNAPSHOTS_DIR="$NIGELOS_ROOT/snapshots"

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

# Initialize snapshots system
init_snapshots() {
    log_info "Initializing system snapshots..."
    mkdir -p "$SNAPSHOTS_DIR"/{current,archives}
    touch "$SNAPSHOTS_DIR/.nigelos-snapshots"
    log_success "Snapshots system initialized"
}

# Create comprehensive system snapshot
create_snapshot() {
    local snapshot_name="${1:-nigelos-$(date +%Y%m%d_%H%M%S)}"
    local snapshot_dir="$SNAPSHOTS_DIR/current/$snapshot_name"

    log_info "Creating system snapshot: $snapshot_name"
    mkdir -p "$snapshot_dir"/{system,user,hardware,software}

    # System Information
    log_info "Gathering system information..."
    cat > "$snapshot_dir/system/info.txt" << EOF
NigelOS System Snapshot
======================
Date: $(date)
User: $(whoami)
Hostname: $(hostname)
Uptime: $(uptime)

System:
$(uname -a)

CPU:
$(lscpu | grep -E "(Architecture|CPU op-mode|Vendor ID|Model name|CPU\(s\)|Thread|Core)" || echo "lscpu not available")

Memory:
$(free -h)

Storage:
$(df -h)

Network Interfaces:
$(ip addr show || ifconfig 2>/dev/null || echo "Network info not available")
EOF

    # Hardware information
    log_info "Gathering hardware information..."
    {
        echo "=== PCI Devices ==="
        lspci 2>/dev/null || echo "lspci not available"
        echo -e "\n=== USB Devices ==="
        lsusb 2>/dev/null || echo "lsusb not available"
        echo -e "\n=== Block Devices ==="
        lsblk 2>/dev/null || echo "lsblk not available"
    } > "$snapshot_dir/hardware/devices.txt"

    # GPU information
    {
        echo "=== GPU Information ==="
        if command -v nvidia-smi &> /dev/null; then
            echo "NVIDIA GPU:"
            nvidia-smi
        fi
        if command -v rocm-smi &> /dev/null; then
            echo "AMD GPU (ROCm):"
            rocm-smi
        fi
        if command -v clinfo &> /dev/null; then
            echo "OpenCL Devices:"
            clinfo
        fi
        echo -e "\n=== Graphics drivers ==="
        lsmod | grep -E "(nvidia|amdgpu|radeon|nouveau|i915)" || echo "No graphics drivers loaded"
    } > "$snapshot_dir/hardware/gpu.txt"

    # Kernel and boot information
    {
        echo "=== Kernel Version ==="
        uname -r
        echo -e "\n=== Kernel Modules ==="
        lsmod
        echo -e "\n=== Boot Parameters ==="
        cat /proc/cmdline 2>/dev/null || echo "Boot parameters not accessible"
    } > "$snapshot_dir/system/kernel.txt"

    # Network configuration
    {
        echo "=== Network Configuration ==="
        echo "Routes:"
        ip route show 2>/dev/null || route -n 2>/dev/null || echo "No route info"
        echo -e "\nDNS:"
        cat /etc/resolv.conf 2>/dev/null || echo "No DNS info"
        echo -e "\nNetworking files:"
        find /etc -name "*network*" -type f 2>/dev/null | head -10
    } > "$snapshot_dir/system/network.txt"

    # Services and systemd
    if command -v systemctl &> /dev/null; then
        log_info "Gathering systemd services..."
        {
            echo "=== Enabled Services ==="
            systemctl list-unit-files --state=enabled --no-pager
            echo -e "\n=== Running Services ==="
            systemctl list-units --type=service --state=running --no-pager
            echo -e "\n=== Failed Services ==="
            systemctl list-units --type=service --state=failed --no-pager
        } > "$snapshot_dir/system/services.txt"
    fi

    # Package information (call our package manager)
    log_info "Gathering package information..."
    if [ -x "$SCRIPT_DIR/package-manager.sh" ]; then
        "$SCRIPT_DIR/package-manager.sh" export
        cp -r "$NIGELOS_ROOT/packages" "$snapshot_dir/software/" 2>/dev/null || true
    fi

    # User environment
    log_info "Gathering user environment..."
    {
        echo "=== Environment Variables ==="
        env | sort
        echo -e "\n=== Shell ==="
        echo "Default shell: $SHELL"
        echo "Current shell: $0"
        echo -e "\n=== User Groups ==="
        groups
        echo -e "\n=== Home Directory Size ==="
        du -sh "$HOME" 2>/dev/null || echo "Cannot calculate home size"
    } > "$snapshot_dir/user/environment.txt"

    # Dotfiles (call our dotfiles manager)
    log_info "Backing up dotfiles..."
    if [ -x "$SCRIPT_DIR/dotfiles-manager.sh" ]; then
        "$SCRIPT_DIR/dotfiles-manager.sh" backup
        cp -r "$NIGELOS_ROOT/dotfiles" "$snapshot_dir/user/" 2>/dev/null || true
    fi

    # Custom applications and scripts
    log_info "Gathering custom applications..."
    {
        echo "=== Custom Scripts in PATH ==="
        for dir in $(echo "$PATH" | tr ':' '\n'); do
            if [[ "$dir" =~ "$HOME" ]] && [ -d "$dir" ]; then
                echo "Directory: $dir"
                ls -la "$dir" 2>/dev/null || true
                echo
            fi
        done

        echo "=== Local Applications ==="
        if [ -d "$HOME/.local/bin" ]; then
            ls -la "$HOME/.local/bin"
        fi
        if [ -d "$HOME/bin" ]; then
            ls -la "$HOME/bin"
        fi
    } > "$snapshot_dir/user/custom-apps.txt"

    # Development environments
    log_info "Gathering development environment info..."
    {
        echo "=== Development Tools ==="

        # Languages and runtimes
        for cmd in python python3 node npm cargo rustc go java javac gcc clang; do
            if command -v "$cmd" &> /dev/null; then
                echo "$cmd: $(command -v "$cmd") - $($cmd --version 2>/dev/null | head -1 || echo 'version unknown')"
            fi
        done

        echo -e "\n=== Python Virtual Environments ==="
        if [ -d "$HOME/.pyenv" ]; then
            echo "PyEnv versions:"
            "$HOME/.pyenv/bin/pyenv" versions 2>/dev/null || true
        fi
        if [ -d "$HOME/.venv" ]; then
            echo "Virtual environments in ~/.venv:"
            ls -la "$HOME/.venv"
        fi

        echo -e "\n=== Node.js/npm ==="
        if command -v node &> /dev/null; then
            echo "Node version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo "Global packages:"
            npm list -g --depth=0 2>/dev/null || true
        fi

        echo -e "\n=== Rust/Cargo ==="
        if command -v cargo &> /dev/null; then
            echo "Rustc version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"
            echo "Installed packages:"
            cargo install --list 2>/dev/null || true
        fi
    } > "$snapshot_dir/software/development.txt"

    # AI/ML specific tools
    log_info "Gathering AI/ML tools..."
    {
        echo "=== AI/ML Tools ==="

        # Ollama
        if command -v ollama &> /dev/null; then
            echo "Ollama version: $(ollama --version 2>/dev/null || echo 'unknown')"
            echo "Ollama models:"
            ollama list 2>/dev/null || echo "Cannot list models"
        fi

        # CUDA
        if command -v nvidia-smi &> /dev/null; then
            echo -e "\nCUDA version:"
            nvcc --version 2>/dev/null || echo "CUDA not available"
        fi

        # ROCm
        if [ -d "/opt/rocm" ]; then
            echo -e "\nROCm installation detected at /opt/rocm"
            if command -v rocm-smi &> /dev/null; then
                echo "ROCm version:"
                cat /opt/rocm/.info/version 2>/dev/null || echo "Version unknown"
            fi
        fi

        # Python ML packages
        if command -v pip &> /dev/null; then
            echo -e "\nPython ML packages:"
            pip list | grep -E "(torch|tensorflow|numpy|pandas|scikit|jupyter|transformers|langchain)" 2>/dev/null || echo "No ML packages found"
        fi
    } > "$snapshot_dir/software/ai-ml.txt"

    # Create snapshot summary
    cat > "$snapshot_dir/SNAPSHOT_INFO.md" << EOF
# NigelOS System Snapshot

**Created:** $(date)
**Hostname:** $(hostname)
**User:** $(whoami)
**System:** $(uname -s) $(uname -r)

## 📋 Contents

### System Information
- **system/info.txt** - Basic system information
- **system/kernel.txt** - Kernel and modules
- **system/network.txt** - Network configuration
- **system/services.txt** - Systemd services

### Hardware
- **hardware/devices.txt** - PCI/USB devices
- **hardware/gpu.txt** - Graphics card information

### Software
- **software/packages/** - Package manager exports
- **software/development.txt** - Development tools
- **software/ai-ml.txt** - AI/ML specific tools

### User Environment
- **user/environment.txt** - User environment variables
- **user/dotfiles/** - Dotfiles backup
- **user/custom-apps.txt** - Custom applications

## 🚀 Restoration

To restore this snapshot on a new system:

1. Install base NigelOS: \`./scripts/deploy.sh\`
2. Restore packages: \`./scripts/package-manager.sh install\`
3. Restore dotfiles: \`./scripts/dotfiles-manager.sh restore\`
4. Review hardware-specific configurations

## 📊 Statistics

- **Files captured:** $(find "$snapshot_dir" -type f | wc -l)
- **Total size:** $(du -sh "$snapshot_dir" | cut -f1)
- **Packages:** $(cat "$snapshot_dir/software/packages/arch/explicit-packages.txt" 2>/dev/null | wc -l || echo "0") arch packages
EOF

    log_success "System snapshot created: $snapshot_dir"

    # Show summary
    echo
    log_info "Snapshot Summary:"
    cat "$snapshot_dir/SNAPSHOT_INFO.md" | grep -E "^\*\*|^-" | sed 's/^/  /'
}

# List available snapshots
list_snapshots() {
    log_info "Available NigelOS snapshots:"
    echo

    if [ ! -d "$SNAPSHOTS_DIR/current" ] || [ -z "$(ls -A "$SNAPSHOTS_DIR/current" 2>/dev/null)" ]; then
        echo "  No snapshots found"
        return
    fi

    for snapshot in "$SNAPSHOTS_DIR/current"/*; do
        if [ -d "$snapshot" ]; then
            snapshot_name=$(basename "$snapshot")
            snapshot_size=$(du -sh "$snapshot" 2>/dev/null | cut -f1)

            if [ -f "$snapshot/SNAPSHOT_INFO.md" ]; then
                snapshot_date=$(grep "Created:" "$snapshot/SNAPSHOT_INFO.md" | cut -d' ' -f2-)
                echo "  📸 $snapshot_name"
                echo "      Date: $snapshot_date"
                echo "      Size: $snapshot_size"
            else
                echo "  📸 $snapshot_name (size: $snapshot_size)"
            fi
            echo
        fi
    done
}

# Archive old snapshots
archive_snapshots() {
    local keep_count="${1:-3}"

    log_info "Archiving old snapshots (keeping $keep_count most recent)..."

    if [ ! -d "$SNAPSHOTS_DIR/current" ]; then
        log_info "No snapshots to archive"
        return
    fi

    # Count current snapshots
    snapshot_count=$(ls -1 "$SNAPSHOTS_DIR/current" 2>/dev/null | wc -l)

    if [ "$snapshot_count" -le "$keep_count" ]; then
        log_info "Only $snapshot_count snapshots found, no archiving needed"
        return
    fi

    # Archive oldest snapshots
    snapshots_to_archive=$((snapshot_count - keep_count))

    log_info "Archiving $snapshots_to_archive old snapshots..."

    # Get oldest snapshots and archive them
    ls -t "$SNAPSHOTS_DIR/current" | tail -n "$snapshots_to_archive" | while read -r snapshot; do
        log_info "  Archiving: $snapshot"

        # Create compressed archive
        tar -czf "$SNAPSHOTS_DIR/archives/${snapshot}.tar.gz" -C "$SNAPSHOTS_DIR/current" "$snapshot"
        rm -rf "$SNAPSHOTS_DIR/current/$snapshot"

        log_success "  ✓ Archived: ${snapshot}.tar.gz"
    done

    log_success "Snapshot archiving complete"
}

# Export snapshot for transfer
export_snapshot() {
    local snapshot_name="$1"

    if [ -z "$snapshot_name" ]; then
        log_error "Please specify a snapshot name"
        list_snapshots
        return 1
    fi

    local snapshot_dir="$SNAPSHOTS_DIR/current/$snapshot_name"
    if [ ! -d "$snapshot_dir" ]; then
        log_error "Snapshot not found: $snapshot_name"
        return 1
    fi

    local export_file="$HOME/nigelos-snapshot-${snapshot_name}.tar.gz"

    log_info "Exporting snapshot for transfer..."
    log_info "Creating: $export_file"

    tar -czf "$export_file" -C "$SNAPSHOTS_DIR/current" "$snapshot_name"

    log_success "Snapshot exported: $export_file"
    log_info "Transfer this file to your new system and extract with:"
    echo "  tar -xzf $(basename "$export_file")"
}

# Main help
show_help() {
    echo "NigelOS System Snapshot Manager"
    echo "==============================="
    echo
    echo "Commands:"
    echo "  init                    - Initialize snapshots system"
    echo "  create [name]          - Create system snapshot"
    echo "  list                   - List available snapshots"
    echo "  archive [keep_count]   - Archive old snapshots (default: keep 3)"
    echo "  export <snapshot_name> - Export snapshot for transfer"
    echo "  help                   - Show this help"
    echo
    echo "Usage: $0 <command> [options]"
}

# Main logic
case "${1:-}" in
    init)
        init_snapshots
        ;;
    create)
        init_snapshots
        create_snapshot "$2"
        ;;
    list)
        list_snapshots
        ;;
    archive)
        archive_snapshots "$2"
        ;;
    export)
        export_snapshot "$2"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac