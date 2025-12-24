# NigelOS

A minimal, thoughtful computing environment built on Arch Linux and Hyprland.

## Philosophy

**Clarity over complexity.** This system exists to support focused work, not to showcase features.

The guiding principle: every tool, every configuration, every line of code should have a clear purpose. If it doesn't serve the work, it doesn't belong here.

## What This Is

A dotfiles repository that tracks my working environment:
- **Hyprland** compositor with macOS-style keybindings
- **Waybar** status bar
- **Dunst** notifications
- **Rofi** launcher
- Clean, consistent Catppuccin theming

This isn't a framework or a distribution. It's a personal workspace, version-controlled.

## Structure

```
nigelos/
├── config/           → System configurations (hypr, waybar, kitty, etc.)
├── scripts/          → Essential deployment and management tools
├── docs/
│   ├── philosophy/   → Design principles and preferences
│   ├── learning/     → Teaching documents for future reference
│   └── troubleshooting.md → Brief log of solved problems
└── README.md         → You are here
```

## Using This

**Deploy configs:**
```bash
./scripts/deploy.sh
```

**Manage dotfiles:**
```bash
./scripts/dotfiles-manager.sh backup   # Save current configs
./scripts/dotfiles-manager.sh restore  # Restore from repo
```

**Manage packages:**
```bash
./scripts/package-manager.sh export    # Save package list
./scripts/package-manager.sh install   # Install from list
```

## Key Bindings

- `Alt+Space` - Application launcher
- `Alt+C/V` - Smart copy/paste (adapts to terminal vs. GUI)
- `Alt+Return` - New terminal
- `Alt+1-5` - Workspace switching
- `Alt+Q` - Close window

The Alt key serves as the primary modifier, creating a familiar macOS-like feel while maintaining the power of a tiling compositor.

## Design Principles

See `docs/philosophy/` for detailed thoughts on:
- System design (finity-design-principles.md)
- Personal preferences and workflow (PREFERENCES.md)
- Future improvements (system-wishlist.md)

## Learning Entries

`docs/learning/` contains teaching documents written to solidify understanding:
- How Linux actually works (from physics to grandma)
- Networking fundamentals
- Arch Linux philosophy and the "DIY cathedral"
- Python as a scripting superpower

These exist because explaining something is the best way to understand it.

## Troubleshooting

See `docs/troubleshooting.md` for a brief log of system issues encountered and resolved. Lessons learned, not verbose postmortems.

---

Built with intention. Maintained with discipline.
