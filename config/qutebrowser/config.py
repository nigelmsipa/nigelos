# Qutebrowser configuration with transparency and Catppuccin Mocha theme

# Load autoconfig (for GUI settings)
config.load_autoconfig()

# Fonts
c.fonts.default_family = "JetBrains Mono Nerd Font"
c.fonts.default_size = "11pt"

# Catppuccin Mocha colors (matching your system)
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"
text = "#cdd6f4"
subtext0 = "#a6adc8"
lavender = "#b4befe"
mauve = "#cba6f7"
sapphire = "#74c7ec"
surface0 = "#313244"
surface1 = "#45475a"

# Background for empty pages only (don't force on actual webpages)
# c.colors.webpage.bg = base

# Completion
c.colors.completion.fg = text
c.colors.completion.odd.bg = mantle
c.colors.completion.even.bg = base
c.colors.completion.category.fg = lavender
c.colors.completion.category.bg = crust
c.colors.completion.category.border.top = crust
c.colors.completion.category.border.bottom = crust
c.colors.completion.item.selected.fg = crust
c.colors.completion.item.selected.bg = mauve
c.colors.completion.item.selected.border.top = mauve
c.colors.completion.item.selected.border.bottom = mauve
c.colors.completion.match.fg = lavender

# Scrollbar
c.colors.completion.scrollbar.fg = mauve
c.colors.completion.scrollbar.bg = crust

# Downloads
c.colors.downloads.bar.bg = base
c.colors.downloads.start.fg = crust
c.colors.downloads.start.bg = sapphire
c.colors.downloads.stop.fg = crust
c.colors.downloads.stop.bg = mauve

# Hints
c.colors.hints.fg = crust
c.colors.hints.bg = lavender
c.colors.hints.match.fg = text

# Messages
c.colors.messages.error.fg = crust
c.colors.messages.error.bg = "#f38ba8"  # red
c.colors.messages.error.border = "#f38ba8"
c.colors.messages.warning.fg = crust
c.colors.messages.warning.bg = "#fab387"  # peach
c.colors.messages.warning.border = "#fab387"
c.colors.messages.info.fg = text
c.colors.messages.info.bg = base

# Prompts
c.colors.prompts.fg = text
c.colors.prompts.bg = base
c.colors.prompts.border = mauve
c.colors.prompts.selected.bg = surface0
c.colors.prompts.selected.fg = text

# Statusbar
c.colors.statusbar.normal.fg = text
c.colors.statusbar.normal.bg = base
c.colors.statusbar.insert.fg = crust
c.colors.statusbar.insert.bg = sapphire
c.colors.statusbar.passthrough.fg = crust
c.colors.statusbar.passthrough.bg = lavender
c.colors.statusbar.command.fg = text
c.colors.statusbar.command.bg = base
c.colors.statusbar.url.fg = text
c.colors.statusbar.url.hover.fg = lavender
c.colors.statusbar.url.success.http.fg = sapphire
c.colors.statusbar.url.success.https.fg = "#a6e3a1"  # green
c.colors.statusbar.url.warn.fg = "#fab387"  # peach

# Tabs
c.colors.tabs.bar.bg = crust
c.colors.tabs.odd.fg = text
c.colors.tabs.odd.bg = mantle
c.colors.tabs.even.fg = text
c.colors.tabs.even.bg = base
c.colors.tabs.selected.odd.fg = crust
c.colors.tabs.selected.odd.bg = mauve
c.colors.tabs.selected.even.fg = crust
c.colors.tabs.selected.even.bg = mauve
c.colors.tabs.pinned.odd.fg = text
c.colors.tabs.pinned.odd.bg = surface0
c.colors.tabs.pinned.even.fg = text
c.colors.tabs.pinned.even.bg = surface1
c.colors.tabs.pinned.selected.odd.fg = crust
c.colors.tabs.pinned.selected.odd.bg = mauve
c.colors.tabs.pinned.selected.even.fg = crust
c.colors.tabs.pinned.selected.even.bg = mauve

# Window transparency - disabled for now, use compositor opacity rules instead
# c.window.transparent = True

# Rounded corners
c.statusbar.padding = {"top": 8, "right": 8, "bottom": 8, "left": 8}
c.tabs.padding = {"top": 8, "right": 8, "bottom": 8, "left": 8}

# Other aesthetic settings
c.tabs.show = "multiple"
c.tabs.position = "top"
c.statusbar.position = "bottom"
c.scrolling.smooth = True

# Start page (optional - set to blank or your preferred page)
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "d": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}",
}
