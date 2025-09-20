# NigelOS System Wishlist

*All the features I want to steal from other systems for my perfect Hyprland setup*

## From DHH's Omarchy

### High Priority - Steal These
- **Key Bindings**: Clean shortcuts that make sense
  - `Super + N` = Editor
  - `Super + B` = Browser, `Super + Shift + B` = Private browser
  - `Super + M` = Music (Spotify)
  - `Super + T` = Activity monitor (btop)
  - `Super + D` = Docker (lazydocker)
  - `Super + A` = ChatGPT webapp
  - `Super + /` = Password manager

- **Web App Launcher**: Turn websites into PWA-style apps
  - Detects default browser, launches with `--app` flag
  - Clean UI, no browser chrome

- **Theme System**: Cohesive color schemes across all apps
  - Tokyo Night, Catppuccin, Rose Pine, etc.
  - Matches Hyprland, kitty, waybar, hyprlock

### Medium Priority
- **Waybar Config**: Clean 26px status bar with good modules
- **Look & Feel Tweaks**: Window gaps, rounded corners, layout options

## From macOS

### High Priority - Need These
- **Text Grabber/OCR**: Live Text equivalent
  - Screenshot + OCR with `grim + tesseract`
  - Copy text directly to clipboard
  - Keybind: `Super + Shift + T`

### Medium Priority
- **Screenshot Enhancements**:
  - Persistent screenshot overlay until dismissed
  - Reference while working on other things
  - Keybind: `Super + Shift + S` (pin), `Super + Escape` (dismiss)

## From Windows PowerToys

### To Research
- Color picker tool
- Text extractor
- Always on top functionality
- Quick file preview

## Custom Ideas

### Workflow Improvements
- Quick note capture (maybe rofi + markdown)
- Project switcher (cd to project dirs quickly)
- Window management presets
- Auto-organize downloads by file type

### System Integration
- Smart wallpaper rotation based on time/mood
- Notification consolidation
- Quick system info overlay
- Battery/performance profiles

## Implementation Notes

**Priority Order:**
1. Omarchy keybindings (easy wins)
2. Web app launcher (useful immediately)
3. Text OCR grabber (medium effort, high value)
4. Theme system (when I want to beautify)
5. Everything else (when bored)

**Sources to Track:**
- DHH's Omarchy configs
- macOS shortcuts and tools
- Linux tiling WM best practices
- r/unixporn inspiration

**Keep It Simple:**
- Minimal, modular implementations
- Hyprland-focused
- Don't break existing workflow
- Easy to remove if I don't like it