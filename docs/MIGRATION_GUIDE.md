# NigelOS Migration Guide

Complete guide for replicating your NigelOS setup on new systems with zero frustration.

## 🚀 Quick Start (New System)

### Method 1: One-Command Setup (Recommended)
```bash
# On your current system - create a snapshot
cd ~/nigelos
./scripts/system-snapshot.sh create my-current-setup
./scripts/system-snapshot.sh export my-current-setup

# Transfer nigelos-snapshot-*.tar.gz to new system
# On new system:
tar -xzf nigelos-snapshot-*.tar.gz
cd nigelos
./scripts/deploy.sh
./scripts/package-manager.sh install
./scripts/dotfiles-manager.sh restore
```

### Method 2: Git Clone + Restore
```bash
# On new system
git clone https://github.com/nigelmsipa/nigelos.git
cd nigelos
./scripts/deploy.sh
./scripts/package-manager.sh install
./scripts/dotfiles-manager.sh restore
./scripts/setup-validator.sh full
```

## 📋 Pre-Migration Checklist

### On Your Current System

1. **Update NigelOS Repository**
   ```bash
   cd ~/nigelos
   git add . && git commit -m "Update before migration"
   git push origin main
   ```

2. **Create Complete Backup**
   ```bash
   # Export all packages
   ./scripts/package-manager.sh export

   # Backup all dotfiles
   ./scripts/dotfiles-manager.sh backup

   # Create system snapshot
   ./scripts/system-snapshot.sh create pre-migration-$(date +%Y%m%d)
   ```

3. **Generate Transfer Package**
   ```bash
   # Create portable snapshot
   ./scripts/system-snapshot.sh export pre-migration-$(date +%Y%m%d)

   # This creates: ~/nigelos-snapshot-*.tar.gz
   # Transfer this file to your new system
   ```

### New System Requirements

- **OS**: Arch Linux (or Arch-based)
- **Desktop**: Any (will be replaced with Hyprland)
- **Internet**: Working connection
- **User**: Non-root user with sudo access

## 🛠️ Detailed Migration Process

### Step 1: Prepare New System

```bash
# Update system
sudo pacman -Syu

# Install git and base-devel
sudo pacman -S git base-devel

# Install yay (AUR helper)
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Step 2: Deploy NigelOS Base

```bash
# Clone or extract NigelOS
git clone https://github.com/nigelmsipa/nigelos.git
# OR: tar -xzf nigelos-snapshot-*.tar.gz

cd nigelos

# Deploy base configuration
./scripts/deploy.sh
```

### Step 3: Restore System State

```bash
# Install all packages from your previous system
./scripts/package-manager.sh install

# Restore your dotfiles and configurations
./scripts/dotfiles-manager.sh restore

# Validate the setup
./scripts/setup-validator.sh full
```

### Step 4: Manual Configuration

Some items may need manual setup:

1. **SSH Keys** (if not included in backup)
   ```bash
   # Copy from old system or regenerate
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. **GPG Keys** (if needed)
   ```bash
   # Export from old system:
   gpg --export-secret-keys > private-keys.asc
   # Import on new system:
   gpg --import private-keys.asc
   ```

3. **Git Configuration**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

4. **AI Models** (Ollama)
   ```bash
   # Install your preferred models
   ollama pull phi3
   ollama pull qwen2
   ```

### Step 5: Verification

```bash
# Run comprehensive validation
./scripts/setup-validator.sh full

# Test key features
# - Alt+I (AI Chat)
# - Alt+Space (App Launcher)
# - Alt+C/V (Smart Copy/Paste)
```

## 🎯 Specific Use Cases

### Case 1: Developer Workstation
```bash
# After base migration, add development extras
./scripts/package-manager.sh install

# Common dev tools
yay -S visual-studio-code-bin docker docker-compose
yay -S nodejs npm python-pip cargo

# Setup development directories
mkdir -p ~/Projects ~/Scripts
```

### Case 2: Gaming Setup
```bash
# Gaming specific packages
yay -S steam lutris wine winetricks

# Graphics drivers (choose one)
yay -S nvidia nvidia-utils  # NVIDIA
yay -S mesa vulkan-radeon   # AMD
```

### Case 3: Content Creation
```bash
# Media creation tools
yay -S obs-studio kdenlive gimp blender

# Audio production
yay -S audacity ardour lmms
```

## 🔧 Troubleshooting

### Common Issues

**1. Hyprland won't start**
```bash
# Check logs
journalctl -u display-manager

# Fallback: start manually
Hyprland
```

**2. Waybar missing icons**
```bash
# Install Nerd Fonts
yay -S ttf-jetbrains-mono-nerd
fc-cache -fv
```

**3. AI Chat not working**
```bash
# Check Ollama status
systemctl status ollama
ollama list

# Install models
ollama pull phi3
```

**4. Package installation fails**
```bash
# Update package databases
sudo pacman -Sy
yay -Sy

# Clear cache if needed
yay -Yc
sudo pacman -Scc
```

### Recovery Options

**If something goes wrong:**

1. **Restore previous dotfiles**
   ```bash
   # Your old files are backed up automatically
   ls ~/.nigelos-restore-backup-*
   ```

2. **Reset to clean state**
   ```bash
   # Remove NigelOS configs
   rm -rf ~/.config/hypr ~/.config/waybar ~/.config/kitty

   # Re-deploy
   ./scripts/deploy.sh
   ```

3. **Use system snapshot**
   ```bash
   # List available snapshots
   ./scripts/system-snapshot.sh list

   # The snapshot contains your old system info for reference
   ```

## 📊 Migration Validation

After migration, run this checklist:

- [ ] Hyprland starts and is stable
- [ ] Waybar displays correctly
- [ ] All keybindings work (Alt+I, Alt+Space, etc.)
- [ ] AI chat functions
- [ ] Applications launch properly
- [ ] GPU acceleration works
- [ ] Audio works
- [ ] Network connectivity
- [ ] Development tools function

Run automated validation:
```bash
./scripts/setup-validator.sh full
```

## 🔄 Ongoing Synchronization

### Keep Multiple Systems in Sync

1. **Regular backups** on your main system:
   ```bash
   # Weekly cron job
   0 0 * * 0 cd ~/nigelos && ./scripts/package-manager.sh export && ./scripts/dotfiles-manager.sh backup && git add . && git commit -m "Weekly backup" && git push
   ```

2. **Sync other systems**:
   ```bash
   # On other systems
   cd ~/nigelos
   git pull
   ./scripts/package-manager.sh install
   ./scripts/dotfiles-manager.sh restore
   ```

### Cloud Backup Strategy

1. **Git repository** (public settings only)
2. **Encrypted cloud storage** (sensitive data)
3. **System snapshots** (complete state)

## 💡 Tips for Success

1. **Test migrations** on a VM first
2. **Keep multiple snapshots** with descriptive names
3. **Document custom changes** in your fork
4. **Validate regularly** with the setup validator
5. **Update incrementally** rather than big bang migrations

## 🆘 Emergency Recovery

If everything breaks:

1. **Boot from live USB**
2. **Mount your system**
3. **Restore from snapshot**:
   ```bash
   # Extract your last working snapshot
   tar -xzf ~/nigelos-snapshot-working.tar.gz
   # Follow restore steps
   ```

## 📞 Getting Help

- Check the validation report: `./scripts/setup-validator.sh report`
- Review system logs: `journalctl -xn`
- NigelOS repository issues: Create issue with validation report

---

*Remember: The goal is zero frustration. If something doesn't work smoothly, it's a bug in the migration system, not user error!*