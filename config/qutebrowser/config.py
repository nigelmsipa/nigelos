# Qutebrowser configuration with transparency and Nord theme

# Load autoconfig (for GUI settings)
config.load_autoconfig()

# Fonts
c.fonts.default_family = "JetBrains Mono Nerd Font"
c.fonts.default_size = "11pt"

# Nord color scheme
# Polar Night (backgrounds)
nord0 = "#2e3440"  # base background
nord1 = "#3b4252"  # lighter background
nord2 = "#434c5e"  # selection background
nord3 = "#4c566a"  # comments, secondary text

# Snow Storm (foregrounds/text)
nord4 = "#d8dee9"  # main text
nord5 = "#e5e9f0"  # brighter text
nord6 = "#eceff4"  # brightest text

# Frost (blue/cyan accents)
nord7 = "#8fbcbb"  # cyan
nord8 = "#88c0d0"  # bright cyan
nord9 = "#81a1c1"  # blue
nord10 = "#5e81ac"  # dark blue

# Aurora (colorful highlights)
nord11 = "#bf616a"  # red
nord12 = "#d08770"  # orange
nord13 = "#ebcb8b"  # yellow
nord14 = "#a3be8c"  # green
nord15 = "#b48ead"  # purple

# Background for empty pages only (don't force on actual webpages)
# c.colors.webpage.bg = base

# Completion
c.colors.completion.fg = nord4
c.colors.completion.odd.bg = nord1
c.colors.completion.even.bg = nord0
c.colors.completion.category.fg = nord8
c.colors.completion.category.bg = nord0
c.colors.completion.category.border.top = nord0
c.colors.completion.category.border.bottom = nord0
c.colors.completion.item.selected.fg = nord6
c.colors.completion.item.selected.bg = nord9
c.colors.completion.item.selected.border.top = nord9
c.colors.completion.item.selected.border.bottom = nord9
c.colors.completion.match.fg = nord8

# Scrollbar
c.colors.completion.scrollbar.fg = nord9
c.colors.completion.scrollbar.bg = nord0

# Downloads
c.colors.downloads.bar.bg = nord0
c.colors.downloads.start.fg = nord0
c.colors.downloads.start.bg = nord8
c.colors.downloads.stop.fg = nord0
c.colors.downloads.stop.bg = nord14

# Hints
c.colors.hints.fg = nord0
c.colors.hints.bg = nord13
c.colors.hints.match.fg = nord4

# Messages
c.colors.messages.error.fg = nord0
c.colors.messages.error.bg = nord11
c.colors.messages.error.border = nord11
c.colors.messages.warning.fg = nord0
c.colors.messages.warning.bg = nord12
c.colors.messages.warning.border = nord12
c.colors.messages.info.fg = nord4
c.colors.messages.info.bg = nord0

# Prompts
c.colors.prompts.fg = nord4
c.colors.prompts.bg = nord0
c.colors.prompts.border = nord9
c.colors.prompts.selected.bg = nord2
c.colors.prompts.selected.fg = nord6

# Statusbar
c.colors.statusbar.normal.fg = nord4
c.colors.statusbar.normal.bg = nord0
c.colors.statusbar.insert.fg = nord0
c.colors.statusbar.insert.bg = nord8
c.colors.statusbar.passthrough.fg = nord0
c.colors.statusbar.passthrough.bg = nord9
c.colors.statusbar.command.fg = nord4
c.colors.statusbar.command.bg = nord0
c.colors.statusbar.url.fg = nord4
c.colors.statusbar.url.hover.fg = nord8
c.colors.statusbar.url.success.http.fg = nord8
c.colors.statusbar.url.success.https.fg = nord14
c.colors.statusbar.url.warn.fg = nord13

# Tabs
c.colors.tabs.bar.bg = nord0
c.colors.tabs.odd.fg = nord4
c.colors.tabs.odd.bg = nord1
c.colors.tabs.even.fg = nord4
c.colors.tabs.even.bg = nord0
c.colors.tabs.selected.odd.fg = nord6
c.colors.tabs.selected.odd.bg = nord9
c.colors.tabs.selected.even.fg = nord6
c.colors.tabs.selected.even.bg = nord9
c.colors.tabs.pinned.odd.fg = nord4
c.colors.tabs.pinned.odd.bg = nord2
c.colors.tabs.pinned.even.fg = nord4
c.colors.tabs.pinned.even.bg = nord3
c.colors.tabs.pinned.selected.odd.fg = nord6
c.colors.tabs.pinned.selected.odd.bg = nord9
c.colors.tabs.pinned.selected.even.fg = nord6
c.colors.tabs.pinned.selected.even.bg = nord9

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
