# NigelOS - AI-Enhanced Hyprland Setup

A beautiful, efficient Linux desktop environment with integrated AI capabilities and **zero-frustration system replication**.

## 🌟 Features

### 🖥️ Desktop Environment
- **Hyprland** - Wayland compositor with smooth animations
- **Waybar** - Status bar with Catppuccin theme
- **macOS-style keybindings** - Familiar Alt-key shortcuts
- **Smart copy/paste** - Context-aware terminal vs app detection

### 🤖 AI Integration
- **Instant AI Chat** - `Alt+I` launches Ollama Phi3 in terminal
- **Multiple Models Tested**:
  - Phi: 75+ tokens/s (speed champion)
  - Qwen: 57 tokens/s (accuracy champion)
  - Mistral: 35 tokens/s (balanced)
- **GPU Accelerated** - Full RX 6600 acceleration confirmed

### 📚 RAG System (Theological Research)
- **15,274 text chunks** from Ellen White books + KJV Bible
- **Sub-second search** through entire theological database
- **GPU-accelerated embeddings** for lightning-fast retrieval
- **ChromaDB vector database** for semantic search

### 🔄 **NEW: System Replication**
- **Package Management** - Complete package backup/restore
- **Dotfiles Sync** - Automated configuration management
- **System Snapshots** - Full system state capture
- **Migration Tools** - One-command system replication
- **Validation Suite** - Automated setup verification

## 🚀 Quick Start

### Fresh Installation
```bash
# Clone the repository
git clone https://github.com/nigelmsipa/nigelos.git
cd nigelos

# One-command setup
./nigelos-manager.sh setup-new
```

### Migrate from Existing System
```bash
# On old system - create migration package
cd ~/nigelos
./nigelos-manager.sh prepare

# Transfer nigelos-snapshot-*.tar.gz to new system
# On new system:
tar -xzf nigelos-snapshot-*.tar.gz
cd nigelos
./nigelos-manager.sh setup-new
```

## 🎯 Master Control

Use the **NigelOS Manager** for all operations:

```bash
./nigelos-manager.sh help
```

### Key Commands
- `status` - Show system status
- `backup` - Create complete system backup
- `prepare` - Prepare for migration
- `setup-new` - Setup on new system
- `validate` - Run full system validation
- `update` - Update entire system
- `setup-ai` - Install AI models
- `setup-dev` - Setup development environment

## 🔧 Advanced Management

### Package Management
```bash
./scripts/package-manager.sh export    # Backup packages
./scripts/package-manager.sh install   # Restore packages
./scripts/package-manager.sh stats     # Show statistics
```

### Dotfiles Management
```bash
./scripts/dotfiles-manager.sh backup   # Backup dotfiles
./scripts/dotfiles-manager.sh restore  # Restore dotfiles
./scripts/dotfiles-manager.sh status   # Show sync status
```

### System Snapshots
```bash
./scripts/system-snapshot.sh create    # Create snapshot
./scripts/system-snapshot.sh list      # List snapshots
./scripts/system-snapshot.sh export    # Export for transfer
```

### Setup Validation
```bash
./scripts/setup-validator.sh full      # Complete validation
./scripts/setup-validator.sh quick     # Quick health check
./scripts/setup-validator.sh report    # Generate report
```

## 📋 System Requirements
- **OS**: Arch Linux (or Arch-based)
- **GPU**: AMD/NVIDIA (tested on RX 6600)
- **Memory**: 8GB+ recommended
- **Storage**: 20GB+ free space

## 🎨 Key Bindings
- `Alt+I` - **AI Chat** 🧠
- `Alt+Space` - Application launcher
- `Alt+C/V` - Smart copy/paste
- `Alt+1-5` - Workspace switching
- `Alt+Return` - New terminal
- `Alt+E` - File manager

## 📦 Included Applications
- **Wallpaper Tools** - Cycling and setting utilities
- **Smart Configs** - Auto-adapts to your system
- **Migration Tools** - Zero-frustration system replication

## 🔗 Related Projects
- **[Echo](https://github.com/nigelmsipa/echo)** - Standalone speech-to-text AI assistant (maintained separately)

## 📚 Documentation

- **[Migration Guide](docs/MIGRATION_GUIDE.md)** - Complete system migration
- **[Preferences](PREFERENCES.md)** - User preferences and workflow
- **Scripts Documentation** - Individual tool help with `<script> help`

## 🔄 Keeping Systems in Sync

### Regular Backup (Recommended)
```bash
# Weekly backup routine
./nigelos-manager.sh backup
./nigelos-manager.sh sync
```

### Multi-System Sync
```bash
# On primary system
./nigelos-manager.sh backup && ./nigelos-manager.sh sync

# On other systems
git pull && ./nigelos-manager.sh restore
```

## 🆘 Troubleshooting

1. **Run validation**: `./nigelos-manager.sh validate`
2. **Check the logs**: Generated reports include detailed diagnostics
3. **Quick fix**: `./nigelos-manager.sh deploy` resets configs
4. **Emergency restore**: Previous configs are automatically backed up

## 🎉 Success Stories

**"I replicated my entire development environment to a new laptop in under 30 minutes!"** - Zero frustration achieved!

---

Built with ❤️ for efficient AI-powered workflows and seamless system management.

I was here
again 
