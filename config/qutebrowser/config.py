# ===================================================================
# LATIN ACCENT - QUTEBROWSER THEME
# Inspired by Acercandr0's Latin Accent Firefox theme
# ===================================================================

# Load autoconfig (for GUI settings)
config.load_autoconfig()

# Fonts
c.fonts.default_family = "JetBrains Mono Nerd Font"
c.fonts.default_size = "11pt"

# ===================================================================
# LATIN ACCENT COLOR SYSTEM
# ===================================================================

# Base colors (light theme)
base_bg = "#ffffff"            # Pure white background
panel_bg = "#f5f5f5"           # Slightly darker panels
text_primary = "#1a1a1a"       # Dark text
text_secondary = "#606060"     # Gray text for inactive elements

# Accent color system (inspired by Latin Accent's system colors)
# You can change this to match your system accent!
accent = "#5e81ac"             # Blue accent (slightly darker for light mode)
accent_subtle = "#e8ecf1"      # Light blue background
hover_bg = "#00000014"         # Subtle dark overlay for hover

# Semantic colors
error = "#bf616a"              # Red
warning = "#d08770"            # Orange (better contrast in light mode)
success = "#7a9a5c"            # Green (darker for better contrast)
info = "#5e81ac"               # Blue

# ===================================================================
# TRANSPARENCY & WINDOW SETTINGS
# ===================================================================

# Enable window transparency (requires compositor support)
# Set to True and use your compositor to adjust opacity
c.window.transparent = True
c.colors.webpage.bg = base_bg
c.colors.webpage.preferred_color_scheme = "light"

# Disable dark mode forcing on websites
c.colors.webpage.darkmode.enabled = False

# ===================================================================
# COMPLETION MENU (Dropdown when typing commands/URLs)
# ===================================================================

c.colors.completion.fg = text_primary
c.colors.completion.odd.bg = panel_bg
c.colors.completion.even.bg = base_bg
c.colors.completion.category.fg = accent
c.colors.completion.category.bg = base_bg
c.colors.completion.category.border.top = base_bg
c.colors.completion.category.border.bottom = base_bg

# Selected item - accent border style
c.colors.completion.item.selected.fg = text_primary
c.colors.completion.item.selected.bg = accent_subtle
c.colors.completion.item.selected.border.top = accent
c.colors.completion.item.selected.border.bottom = accent
c.colors.completion.match.fg = accent

# Scrollbar
c.colors.completion.scrollbar.fg = accent
c.colors.completion.scrollbar.bg = base_bg

# ===================================================================
# DOWNLOADS BAR
# ===================================================================

c.colors.downloads.bar.bg = base_bg
c.colors.downloads.start.fg = "#ffffff"
c.colors.downloads.start.bg = info
c.colors.downloads.stop.fg = "#ffffff"
c.colors.downloads.stop.bg = success
c.colors.downloads.error.fg = "#ffffff"
c.colors.downloads.error.bg = error

# ===================================================================
# HINTS (Link selection mode)
# ===================================================================

c.colors.hints.fg = "#ffffff"
c.colors.hints.bg = accent
c.colors.hints.match.fg = text_primary

# ===================================================================
# MESSAGES (Info/Error/Warning bars)
# ===================================================================

c.colors.messages.error.fg = "#ffffff"
c.colors.messages.error.bg = error
c.colors.messages.error.border = error

c.colors.messages.warning.fg = "#ffffff"
c.colors.messages.warning.bg = warning
c.colors.messages.warning.border = warning

c.colors.messages.info.fg = text_primary
c.colors.messages.info.bg = base_bg
c.colors.messages.info.border = info

# ===================================================================
# PROMPTS (Dialog boxes)
# ===================================================================

c.colors.prompts.fg = text_primary
c.colors.prompts.bg = panel_bg
c.colors.prompts.border = accent
c.colors.prompts.selected.bg = accent_subtle
c.colors.prompts.selected.fg = text_primary

# ===================================================================
# STATUSBAR (Bottom bar showing URL and mode)
# ===================================================================

# Normal mode - minimal, transparent feel
c.colors.statusbar.normal.fg = text_secondary
c.colors.statusbar.normal.bg = base_bg

# Insert mode - accent color
c.colors.statusbar.insert.fg = "#ffffff"
c.colors.statusbar.insert.bg = accent

# Passthrough mode
c.colors.statusbar.passthrough.fg = "#ffffff"
c.colors.statusbar.passthrough.bg = info

# Command mode
c.colors.statusbar.command.fg = text_primary
c.colors.statusbar.command.bg = base_bg

# URL colors
c.colors.statusbar.url.fg = text_secondary
c.colors.statusbar.url.hover.fg = accent
c.colors.statusbar.url.success.http.fg = text_primary
c.colors.statusbar.url.success.https.fg = success
c.colors.statusbar.url.warn.fg = warning
c.colors.statusbar.url.error.fg = error

# ===================================================================
# TABS (Mimicking Latin Accent's tab style)
# ===================================================================

# Tab bar background - transparent/minimal
c.colors.tabs.bar.bg = base_bg

# Inactive tabs - subtle, low opacity appearance
c.colors.tabs.odd.fg = text_secondary
c.colors.tabs.odd.bg = base_bg
c.colors.tabs.even.fg = text_secondary
c.colors.tabs.even.bg = base_bg

# Active tab - accent border style (like Latin Accent)
c.colors.tabs.selected.odd.fg = text_primary
c.colors.tabs.selected.odd.bg = base_bg
c.colors.tabs.selected.even.fg = text_primary
c.colors.tabs.selected.even.bg = base_bg

# Pinned tabs
c.colors.tabs.pinned.odd.fg = text_secondary
c.colors.tabs.pinned.odd.bg = base_bg
c.colors.tabs.pinned.even.fg = text_secondary
c.colors.tabs.pinned.even.bg = base_bg

c.colors.tabs.pinned.selected.odd.fg = text_primary
c.colors.tabs.pinned.selected.odd.bg = base_bg
c.colors.tabs.pinned.selected.even.fg = text_primary
c.colors.tabs.pinned.selected.even.bg = base_bg

# Tab indicator for selected tab (accent color)
c.colors.tabs.indicator.start = accent
c.colors.tabs.indicator.stop = accent
c.colors.tabs.indicator.error = error

# ===================================================================
# LAYOUT & SPACING (Latin Accent style - clean and spacious)
# ===================================================================

# Generous padding for modern feel
c.statusbar.padding = {"top": 8, "right": 8, "bottom": 8, "left": 8}
c.tabs.padding = {"top": 8, "right": 10, "bottom": 8, "left": 10}

# Tab settings
c.tabs.position = "top"
c.tabs.title.format = "{audio}{current_title}"
c.tabs.title.format_pinned = "{audio}"

# Tab width - let them breathe
c.tabs.width = "10%"
c.tabs.max_width = 250
c.tabs.min_width = 100

# Indicator style - modern thin line
c.tabs.indicator.width = 2

# Statusbar position
c.statusbar.position = "bottom"

# ===================================================================
# SCROLLING & ANIMATIONS
# ===================================================================

c.scrolling.smooth = True
c.scrolling.bar = "always"

# ===================================================================
# START PAGE & SEARCH
# ===================================================================

c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "d": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}",
}

# ===================================================================
# ADDITIONAL AESTHETIC TWEAKS
# ===================================================================

# Zoom levels
c.zoom.default = "100%"

# Show tab close button only on hover (optional)
c.tabs.close_mouse_button = "middle"
c.tabs.mousewheel_switching = False

# ===================================================================
# FULLSCREEN MODE SETTINGS
# ===================================================================

# Keep tabs visible in fullscreen
# Options: 'always', 'never', 'multiple', 'switching'
c.tabs.show = "always"

# Keep statusbar visible in fullscreen
# Options: 'always', 'never', 'in-mode'
c.statusbar.show = "always"

# Content to show/hide in fullscreen
# This controls what gets hidden when you press F11
c.content.fullscreen.overlay_timeout = 3000  # Show overlays for 3 seconds
c.content.fullscreen.window = True  # Use native fullscreen so Hyprland rules match

# ===================================================================
# KEYBINDINGS
# ===================================================================

# Super+F for fullscreen
config.bind('<Meta+f>', 'fullscreen')

# Slash for open (vim-style with full completion)
config.bind('/', 'cmd-set-text -s :open')

# ===================================================================
# COMPOSITOR HINT
# ===================================================================
# For best results with transparency:
# - On X11 with picom: use --opacity-rule '90:class_g = "qutebrowser"'
# - On Wayland: use your compositor's opacity settings
#
# Example picom config:
#   opacity-rule = [
#     "90:class_g = 'qutebrowser'"
#   ];
# ===================================================================
