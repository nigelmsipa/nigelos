config.load_autoconfig()

# Gruvbox Light colors
bg = "#fbf1c7"
bg_dark = "#ebdbb2"
fg = "#3c3836"
fg_dim = "#7c6f64"
red = "#cc241d"
green = "#98971a"
yellow = "#d79921"
blue = "#458588"
purple = "#b16286"
aqua = "#689d6a"
orange = "#d65d0e"

# Completion
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg
c.colors.completion.even.bg = bg_dark
c.colors.completion.category.fg = blue
c.colors.completion.category.bg = bg
c.colors.completion.category.border.top = bg
c.colors.completion.category.border.bottom = bg
c.colors.completion.item.selected.fg = bg
c.colors.completion.item.selected.bg = blue
c.colors.completion.item.selected.border.top = blue
c.colors.completion.item.selected.border.bottom = blue
c.colors.completion.match.fg = orange
c.colors.completion.scrollbar.fg = fg_dim
c.colors.completion.scrollbar.bg = bg

# Downloads
c.colors.downloads.bar.bg = bg
c.colors.downloads.start.fg = bg
c.colors.downloads.start.bg = blue
c.colors.downloads.stop.fg = bg
c.colors.downloads.stop.bg = green
c.colors.downloads.error.fg = bg
c.colors.downloads.error.bg = red

# Hints
c.colors.hints.fg = bg
c.colors.hints.bg = yellow
c.colors.hints.match.fg = fg_dim

# Messages
c.colors.messages.error.fg = bg
c.colors.messages.error.bg = red
c.colors.messages.error.border = red
c.colors.messages.warning.fg = bg
c.colors.messages.warning.bg = orange
c.colors.messages.warning.border = orange
c.colors.messages.info.fg = fg
c.colors.messages.info.bg = bg
c.colors.messages.info.border = bg

# Prompts
c.colors.prompts.fg = fg
c.colors.prompts.bg = bg_dark
c.colors.prompts.border = blue
c.colors.prompts.selected.bg = bg
c.colors.prompts.selected.fg = fg

# Statusbar
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.insert.fg = bg
c.colors.statusbar.insert.bg = green
c.colors.statusbar.passthrough.fg = bg
c.colors.statusbar.passthrough.bg = blue
c.colors.statusbar.command.fg = fg
c.colors.statusbar.command.bg = bg
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.hover.fg = blue
c.colors.statusbar.url.success.http.fg = fg
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.warn.fg = orange
c.colors.statusbar.url.error.fg = red

# Tabs
c.colors.tabs.bar.bg = bg
c.colors.tabs.odd.fg = fg_dim
c.colors.tabs.odd.bg = bg
c.colors.tabs.even.fg = fg_dim
c.colors.tabs.even.bg = bg
c.colors.tabs.selected.odd.fg = fg
c.colors.tabs.selected.odd.bg = bg_dark
c.colors.tabs.selected.even.fg = fg
c.colors.tabs.selected.even.bg = bg_dark
c.colors.tabs.indicator.start = blue
c.colors.tabs.indicator.stop = green
c.colors.tabs.indicator.error = red

# Webpage
c.colors.webpage.bg = bg
c.colors.webpage.preferred_color_scheme = "light"

# Font
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.fonts.default_size = "11pt"

# Padding
c.statusbar.padding = {"top": 6, "right": 8, "bottom": 6, "left": 8}
c.tabs.padding = {"top": 6, "right": 8, "bottom": 6, "left": 8}

# Keybindings
config.bind(',gt', 'spawn --userscript get_transcript')
config.bind(',gh', 'hint links spawn --userscript get_transcript')


# Transcript to AI - grab transcript and open AI in new window (Niri tiles it)
config.bind(',gg', 'spawn --userscript transcript_to_ai grok')
config.bind(',gc', 'spawn --userscript transcript_to_ai claude')
config.bind(',go', 'spawn --userscript transcript_to_ai chatgpt')
config.bind(',ge', 'spawn --userscript transcript_to_ai gemini')


# Microphone access
config.set('content.media.audio_capture', True, 'https://chatgpt.com')
config.set('content.media.audio_capture', True, 'https://claude.ai')
config.set('content.media.audio_capture', True, 'https://gemini.google.com')
config.set('content.media.audio_capture', True, 'https://grok.com')

# Clipboard access for AI sites (needed for auto-paste greasemonkey script)
config.set('content.javascript.clipboard', 'access-paste', 'https://grok.com')
