# Nigel OS - AI-Enhanced Hyprland Setup for the futur


A beautiful, efficient Linux desktop environment with integrated AI capabilities.

## Features

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

## 🚀 Deployment

### New Machine Setup
```bash
# Clone the repository
git clone https://github.com/nigelmsipa/nigelos.git
cd nigelos

# Run deployment script
./deploy.sh
```

The deployment script will:
- Auto-detect your monitor and username
- Set up all config files with correct paths
- Copy applications (wallpaper tools, Echo AI)
- Create necessary directories

### Manual Setup (if needed)
1. Copy configs to `~/.config/`
2. Install dependencies: `hyprland waybar kitty rofi`
3. Set up wallpapers in `~/Pictures/Wallpapers/`

## 🎯 Quick Start

### AI Chat
Press `Alt+I` for instant AI assistance!

### Key Bindings
- `Alt+C/V` - Smart copy/paste (detects terminal vs apps)
- `Alt+Space` - Application launcher
- `Alt+I` - **AI Chat** 🧠
- `Alt+1-5` - Workspace switching
- `Alt+Return` - New terminal

## 📋 System Requirements
- AMD/NVIDIA GPU (tested on RX 6600)
- Ollama with Phi3/Qwen models
- Hyprland + Waybar + Kitty + Rofi

## 📦 Included Applications
- **Echo AI** - Voice and chat AI assistant
- **Wallpaper Tools** - Cycling and setting utilities
- **Smart Configs** - Auto-adapts to your system

Built with ❤️ for efficient AI-powered workflows.
