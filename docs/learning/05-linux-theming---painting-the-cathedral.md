# Entry 5: Linux Theming - Painting the Cathedral

### What IS Theming?

**Simple answer**: Changing the colors and appearance of your desktop environment.

**Better answer**: Creating a cohesive visual language across all your applications so your system feels unified and intentional.

**The philosophy**: Your workspace should reflect how you think. Some people think in warm pastels, others in arctic blues, others in neon cyberpunk.

---

### The Components of a Theme

A complete desktop theme consists of:

#### 1. **Color Palette** (The Foundation)
```
Your 10-16 essential colors:
├── Background (dark or light)
├── Foreground (text color)
├── Surface (UI elements)
├── Accent colors (highlights, selections)
│   ├── Blue
│   ├── Green
│   ├── Yellow
│   ├── Red
│   └── Purple/Pink
└── Dim colors (less important text)
```

#### 2. **Window Manager Theme**
- Border colors
- Title bar colors
- Active vs inactive window colors
- In Hyprland: Set in `hyprland.conf`

#### 3. **Status Bar Theme**
- Waybar, Polybar, etc.
- Background, module colors, icons
- Configured in CSS or config files

#### 4. **Application Launchers**
- Rofi, Wofi, dmenu
- Popup menus, search bars
- Usually RASI or CSS configs

#### 5. **Notifications**
- Dunst, Mako, SwayNC
- Toast notifications in corner
- Urgency levels (low/normal/critical)

#### 6. **Terminal Colors**
- The classic 16 ANSI colors
- Background, foreground, cursor
- Set in kitty.conf, alacritty.yml, etc.

#### 7. **GTK/Qt Themes** (GUI Apps)
- Firefox, file managers, settings apps
- More complex, often use pre-made themes
- Applied system-wide via `~/.config/gtk-3.0/`

#### 8. **Icons**
- File manager icons, app icons
- Separate from colors
- Installed system-wide

#### 9. **Fonts**
- Not technically theme, but affects aesthetics
- Nerd Fonts for icons in terminal

#### 10. **Wallpaper**
- Ties everything together
- Can drive the entire theme (with pywal)

---

### The Big Theme Families

#### **Catppuccin** 🍮
**Philosophy**: Cozy, soft, pastel café aesthetic

**Variants**:
- Latte (light) - Espresso and cream
- Frappé (light-medium) - Iced coffee
- Macchiato (medium-dark) - Less sweet
- Mocha (dark) - Strong coffee

**Colors**:
```
Background: #1e1e2e (dark purple-gray)
Foreground: #cdd6f4 (soft white-blue)
Blue:       #89b4fa (selected items)
Lavender:   #b4befe (borders, accents)
Pink:       #f5c2e7 (highlights)
Red:        #f38ba8 (errors, critical)
```

**Why popular**:
- Official themes for 100+ applications
- Extremely cohesive across entire system
- Active community, well-maintained
- Just works out of the box

**Best for**: People who want everything to match perfectly without effort

---

#### **Nord** ❄️
**Philosophy**: Arctic minimalism, Scandinavian design

**Colors**:
```
Polar Night (backgrounds):
  #2e3440 (darkest)
  #3b4252
  #434c5e
  #4c566a (lightest dark)

Snow Storm (text):
  #d8dee9 (dim)
  #e5e9f0
  #eceff4 (brightest)

Frost (accents):
  #8fbcbb (cyan-ish)
  #88c0d0 (frost blue - THE Nord color)
  #81a1c1 (muted blue)
  #5e81ac (darker blue)

Aurora (highlights):
  #bf616a (red)
  #d08770 (orange)
  #ebcb8b (yellow)
  #a3be8c (green)
  #b48ead (purple)
```

**Why popular**:
- Extremely easy on eyes
- Professional, minimalist
- Low contrast = less eye strain
- "Grown up" aesthetic

**Best for**: Long coding sessions, professional work, if you hate bright colors

---

#### **Tokyo Night** 🌃
**Philosophy**: Neon-lit Tokyo streets at night, cyberpunk vibes

**Variants**:
- Night (dark)
- Storm (darker)
- Day (light)

**Colors**:
```
Background: #1a1b26 (deep blue-black)
Foreground: #c0caf5 (bright blue-white)
Blue:       #7aa2f7 (bright electric blue)
Purple:     #bb9af7 (neon purple)
Cyan:       #7dcfff (bright cyan)
Green:      #9ece6a (lime green)
Red:        #f7768e (hot pink-red)
Orange:     #ff9e64 (neon orange)
```

**Why popular**:
- Looks AMAZING with transparency
- Vibrant without being obnoxious
- Cyberpunk aesthetic
- Great contrast

**Best for**: If you want that Blade Runner / Ghost in the Shell vibe

---

#### **Gruvbox** 📦
**Philosophy**: Retro, warm, earthy 70s poster colors

**Variants**:
- Dark (hard, medium, soft)
- Light (hard, medium, soft)

**Colors**:
```
Background: #282828 (dark brown)
Foreground: #ebdbb2 (cream)
Red:        #cc241d (muted red)
Green:      #98971a (olive green)
Yellow:     #d79921 (gold)
Blue:       #458588 (muted blue)
Purple:     #b16286 (mauve)
Aqua:       #689d6a (teal)
Orange:     #d65d0e (rust)
```

**Why popular**:
- Been around forever (since 2012)
- Warm, comfortable, nostalgic
- Low contrast = easy on eyes
- Unique vintage aesthetic

**Best for**: If you like warm colors, retro vibes, coffee shop coding

---

#### **Dracula** 🧛
**Philosophy**: Dark purple vampire aesthetic, iconic

**Colors**:
```
Background: #282a36 (dark purple-gray)
Foreground: #f8f8f2 (off-white)
Selection:  #44475a (purple-gray)
Comment:    #6272a4 (muted blue-purple)
Cyan:       #8be9fd (bright cyan)
Green:      #50fa7b (bright green)
Orange:     #ffb86c (orange)
Pink:       #ff79c6 (hot pink)
Purple:     #bd93f9 (lavender)
Red:        #ff5555 (bright red)
Yellow:     #f1fa8c (bright yellow)
```

**Why popular**:
- THE classic dark theme
- High contrast, very readable
- Bright accent colors
- Recognizable everywhere

**Best for**: Night owls, vampire coders, if you want instant recognition

---

#### **Rosé Pine** 🌹
**Philosophy**: Low contrast, elegant, subtle

**Variants**:
- Base (dark)
- Moon (darker)
- Dawn (light)

**Colors**:
```
Background: #191724 (very dark purple)
Surface:    #1f1d2e (slightly lighter)
Foreground: #e0def4 (soft white)
Muted:      #6e6a86 (very dim)
Rose:       #ebbcba (muted pink)
Pine:       #31748f (muted teal)
Gold:       #f6c177 (soft gold)
Iris:       #c4a7e7 (soft purple)
```

**Why popular**:
- Lowest eye strain
- Sophisticated, elegant
- Great for reading/writing
- Unique muted aesthetic

**Best for**: Long reading sessions, writing, if you find other themes too harsh

---

### How Theming Actually Works

#### **The File Structure**:

```
~/.config/
├── hypr/
│   └── hyprland.conf          → Window borders, gaps, colors
├── waybar/
│   ├── config                 → Bar layout
│   └── style.css              → Bar colors, fonts
├── rofi/
│   └── config.rasi            → Launcher colors
├── dunst/
│   └── dunstrc                → Notification colors
├── kitty/
│   └── kitty.conf             → Terminal colors
└── gtk-3.0/
    └── settings.ini           → GUI app theme
```

#### **How I Changed Your Theme**:

**What I did when switching you to Nord:**

1. **Opened your rofi config** (`~/.config/rofi/config.rasi`)
2. **Found the color variables**:
   ```css
   * {
       bg: rgba(30, 30, 46, 0.85);    ← Catppuccin background
       blue: #89b4fa;                  ← Catppuccin blue
       ...
   }
   ```
3. **Replaced with Nord colors**:
   ```css
   * {
       bg: rgba(46, 52, 64, 0.85);    ← Nord background
       blue: #88c0d0;                  ← Nord frost blue
       ...
   }
   ```
4. **Did the same for dunst config**
5. **Restarted dunst** so changes take effect

**That's literally it.** Just swapping hex codes.

---

### Theme Application Methods

#### **Method 1: Manual (What We Just Did)**

**Process**:
1. Pick a theme (Nord, Catppuccin, etc.)
2. Find official color palette
3. Manually edit each config file
4. Replace hex codes with new theme colors
5. Reload/restart apps

**Pros**:
- Full control
- Understand exactly what you're doing
- Learn your configs

**Cons**:
- Time consuming
- Have to theme each app separately
- Easy to miss apps

---

#### **Method 2: Theme Switcher Scripts**

**How it works**:
- Create multiple config files:
  - `rofi-catppuccin.rasi`
  - `rofi-nord.rasi`
  - `rofi-tokyonight.rasi`
- Script copies the right one to `config.rasi`
- Run script, switch theme instantly

**Example script**:
```bash
#!/bin/bash
# theme-switcher.sh

THEME=$1  # catppuccin, nord, tokyonight

cp ~/.config/rofi/themes/rofi-${THEME}.rasi ~/.config/rofi/config.rasi
cp ~/.config/dunst/themes/dunst-${THEME} ~/.config/dunst/dunstrc
killall dunst && dunst &

echo "Switched to $THEME"
```

**Pros**:
- Switch themes in 1 second
- Can have 10+ themes ready
- Easy to experiment

**Cons**:
- Have to maintain multiple config files
- Still manual initial setup

---

#### **Method 3: Dynamic Theme Generators**

##### **Pywal** (Most Popular)

**How it works**:
1. You set a wallpaper
2. Pywal extracts 16 colors from the image
3. Generates theme files for all your apps
4. Applies theme automatically

**Usage**:
```bash
# Set wallpaper, generate theme
wal -i /path/to/wallpaper.png

# Your entire system re-themes based on wallpaper colors
```

**Magic**: It creates:
- `~/.cache/wal/colors.json` (extracted colors)
- `~/.cache/wal/colors-rofi.rasi`
- `~/.cache/wal/colors-kitty.conf`
- And 50+ other app configs

**Then your configs just import these**:
```css
/* In rofi config */
@import "~/.cache/wal/colors-rofi.rasi"
```

**Pros**:
- Change wallpaper = instant new theme
- Always cohesive (colors from same image)
- Supports 100+ apps
- Super cool automation

**Cons**:
- Colors might not be perfect
- Can look weird if wallpaper has ugly colors
- Less control

---

##### **Matugen** (Modern Alternative)

**How it works**:
- Uses Material Design 3 color algorithm
- Extracts colors more intelligently
- Better contrast, more readable
- You already have templates: `~/.config/matugen/templates/`

**Similar to pywal but smarter color extraction**

---

#### **Method 4: Complete Theme Managers**

**Tools**: `stylix` (NixOS), `flavours`, `base16`

**How it works**:
- Declarative theme management
- Define theme once, applies everywhere
- Usually requires specific distro/setup

**For advanced users**

---

### Creating Your Own Theme

**Want to make something truly yours?**

#### **Step 1: Pick Your Base Colors**

Start with 5 core colors:

```
1. Background   (dark or light)
2. Foreground   (text)
3. Accent 1     (your signature color - the one that defines YOU)
4. Accent 2     (complementary)
5. Critical     (errors, warnings)
```

**Tools to help**:
- **Coolors.co** - Generate color palettes
- **Adobe Color** - Color wheel tool
- **Paletton** - Color scheme designer

**Example custom palette**:
```
Background: #1a1d2e  (dark navy)
Foreground: #e0e0e0  (light gray)
Accent 1:   #ff6b9d  (hot pink - YOUR signature)
Accent 2:   #4fd6be  (teal)
Critical:   #ff5370  (red)
```

#### **Step 2: Expand to Full Palette**

Add variations:
```
Dim text:     #a0a0a0
Surface:      #252836  (slightly lighter than background)
Border:       Your Accent 1 at 50% opacity
Highlight:    Your Accent 1 at 20% opacity
```

#### **Step 3: Apply to Configs**

Go through each app:
- Rofi: Use your palette
- Dunst: Use your palette
- Waybar: Use your palette
- Terminal: Generate 16 ANSI colors based on your palette

#### **Step 4: Test and Refine**

**Check**:
- Is text readable?
- Do colors clash?
- Is contrast sufficient?
- Does it feel cohesive?

**Adjust** until it feels right

#### **Step 5: Document It**

Create `~/nigelos/docs/philosophy/custom-theme.md`:
```markdown
# My Custom Theme

## Philosophy
Why these colors represent me...

## Palette
Background: #1a1d2e
Accent: #ff6b9d (signature pink)
...

## Usage
To apply: ...
```

---

### The Reality of Theming

**Truth 1**: Most people use existing themes
- 95% use Catppuccin/Nord/Tokyo Night/Dracula
- It's not "less creative" - these themes are GOOD
- They've been refined by thousands of users

**Truth 2**: Custom themes take HOURS
- Easy to pick colors
- Hard to make them work everywhere
- Harder to make them look good

**Truth 3**: You'll probably change themes
- Everyone does
- Nord today, Tokyo Night next month
- That's fine, it's part of the journey

**Truth 4**: Theme isn't everything
- Functionality > aesthetics
- If Nord helps you focus, use Nord
- If you're torn between themes, pick one and move on

---

### Your Current Situation

**You have**:
- Transparent terminal ✓
- Transparent browser ✓
- Dark mode preference ✓
- Conflicted between Catppuccin and Nord

**The conflict**:
- Catppuccin = Warmer, softer, cozy (coffee shop)
- Nord = Cooler, sharper, minimal (Scandinavian office)

**Solutions**:

**Option 1: Hybrid**
- Keep Nord's cool blues
- Add warmer accent colors
- Best of both worlds

**Option 2: Try Tokyo Night**
- In between Catppuccin and Nord
- Dark like Nord, vibrant like Catppuccin

**Option 3: Stick with one**
- Pick Catppuccin or Nord
- Use it for a week
- See which feels more "you"
- Don't overthink it

**Option 4: Custom theme**
- Pick YOUR signature color
- Build palette around it
- Takes time but totally yours

---

### Practical Commands

#### **Where Themes Live**:
```bash
# Your current theme files
~/.config/rofi/config.rasi
~/.config/dunst/dunstrc
~/.config/waybar/style.css
~/.config/kitty/kitty.conf

# Reload apps after changes
killall dunst && dunst &       # Reload notifications
# Rofi: automatic on next launch
# Waybar: killall waybar && waybar &
# Hyprland: hyprctl reload
```

#### **Backup Before Experimenting**:
```bash
# Before trying new theme
cp ~/.config/rofi/config.rasi ~/.config/rofi/config.rasi.backup

# Restore if you hate it
cp ~/.config/rofi/config.rasi.backup ~/.config/rofi/config.rasi
```

#### **Quick Theme Test**:
```bash
# Edit rofi colors
nvim ~/.config/rofi/config.rasi

# Test immediately
rofi -show drun

# Like it? Keep it. Hate it? Ctrl+Z in nvim
```

---

### Resources

**Theme Galleries**:
- r/unixporn (Reddit) - See themes in action
- dotfiles.github.io - Browse configs
- Catppuccin.com - Official palettes

**Color Tools**:
- coolors.co - Generate palettes
- color.adobe.com - Color wheel
- contrast-ratio.com - Check readability

**Official Theme Sites**:
- nordtheme.com
- catppuccin.com
- github.com/enkia/tokyo-night-vscode-theme
- github.com/morhetz/gruvbox
- draculatheme.com
- rosepinetheme.com

---

### The Philosophy of Theming

**Why does this matter?**

Your workspace is where you spend hours every day. The colors you see affect:
- Focus
- Mood
- Eye strain
- Sense of ownership

**Theming is not superficial**. It's about creating an environment that supports your work.

**The goal**: Not to have the prettiest setup for screenshots. The goal is to have a setup that feels like HOME.

---

### Final Wisdom

**Don't overthink it.**

You're conflicted between Nord and Catppuccin? Flip a coin. Use one for a week. You'll know.

**The best theme is the one you stop thinking about.**

When the colors fade into the background and you just *work*, that's when you've found your theme.

**Remember**: The cathedral's architecture matters more than its paint. Get your workflow right first, make it pretty second.

---

**End of Entry 5**

*Next: Understanding window managers and compositors - How Hyprland actually works*
