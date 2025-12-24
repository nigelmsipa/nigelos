# Entry 3: Arch Linux - The DIY Cathedral

### What IS Arch Linux?

**Simple answer**: A lightweight, flexible Linux distribution that lets you build your system exactly how you want it.

**Better answer**: Arch is a rolling-release distribution built on the philosophy that you should understand and control every piece of software on your computer.

**The philosophy**: KISS (Keep It Simple, Stupid)
- "Simple" doesn't mean "easy for beginners"
- "Simple" means "minimal, transparent, without unnecessary abstractions"
- You build your system from the ground up
- No bloat—only install what you need

---

### The Arch Philosophy: Why It's Different

Most Linux distributions (Ubuntu, Fedora, Mint) follow this approach:
- Pre-install lots of software "just in case"
- Hide complexity from users
- Make decisions for you (desktop environment, default apps, etc.)
- Goal: Ready to use out of the box

**Arch Linux follows the opposite approach:**
- Install almost nothing by default (just base system)
- Expose complexity, don't hide it
- Make NO decisions for you
- Goal: You learn the system and build it YOUR way

#### The Arch Way:

1. **Simplicity** - No unnecessary additions or modifications
2. **Modernity** - Bleeding-edge software (latest versions)
3. **Pragmatism** - Prioritize functionality over ideology
4. **User-centrality** - Put the user in control, expect competence
5. **Versatility** - General-purpose base, customize for any use case

**Translation**: Arch respects you enough to let you shoot yourself in the foot. It assumes you WANT to understand how things work.

---

### Rolling Release: The Continuous Update Model

#### Traditional Linux distributions (Ubuntu, Debian):

- **Fixed releases**: Ubuntu 22.04, 24.04, etc.
- Major updates every 6 months or 2 years
- Between releases: only security patches
- Eventually: need to upgrade to new version (reinstall or risky upgrade)

#### Arch Linux:

- **Rolling release**: No version numbers
- Continuous updates forever
- Always the latest software
- Never need to reinstall or do major upgrades

**Analogy**:
- Ubuntu = Buying a new car every 2 years
- Arch = Your car gets new parts continuously, stays current forever

**The tradeoff**:
- ✅ Always latest features
- ✅ Never outdated
- ❌ Occasionally updates break things
- ❌ Need to pay attention to update warnings

---

### The Installation Process: Why It's Famous

**Other distros**: Boot installer, click Next → Next → Finish, done.

**Arch**: No installer. You build the system manually using the command line.

#### The infamous Arch installation (simplified):

**Step 1: Boot into live environment**
- Boot from USB stick
- You're in a command prompt, no GUI
- You're root (full system control)

**Step 2: Partition the disk**
```bash
fdisk /dev/sda  # Manually create partitions
```
- You decide: How big should root partition be? Separate home partition? Swap space?
- No wizard, you use tools like fdisk/cfdisk/parted

**Step 3: Format partitions**
```bash
mkfs.ext4 /dev/sda1  # Format root partition as ext4
mkswap /dev/sda2     # Create swap space
```
- You choose the filesystem (ext4, btrfs, xfs, etc.)

**Step 4: Mount filesystems**
```bash
mount /dev/sda1 /mnt  # Mount root partition
```

**Step 5: Install base system**
```bash
pacstrap /mnt base linux linux-firmware
```
- Installs: kernel, basic utilities, nothing else
- No desktop environment, no web browser, no music player
- Bare bones

**Step 6: Configure the system**
```bash
arch-chroot /mnt  # Enter the new system
```
- Set timezone, locale, hostname
- Configure bootloader (GRUB)
- Set root password
- Create user account

**Step 7: Reboot**
- Remove USB
- Boot into... a command prompt
- No desktop environment yet—you haven't installed one

#### Why this process?

**You're forced to learn:**
- How disk partitioning works
- What a bootloader does
- How Linux boots
- What packages are essential
- How to configure a system from scratch

**Result**: You understand your system deeply because you built it piece by piece.

---

### Package Management: Pacman & AUR

#### Pacman: The Package Manager

**What it is**: Arch's tool for installing/updating/removing software

**Common commands**:

```bash
# Update system (ALWAYS do this before installing anything)
sudo pacman -Syu

# Install a package
sudo pacman -S firefox

# Remove a package
sudo pacman -R firefox

# Remove package + unused dependencies
sudo pacman -Rns firefox

# Search for a package
pacman -Ss keyword

# Get info about installed package
pacman -Qi packagename

# List all installed packages
pacman -Q
```

**Key concept: Dependency resolution**
- You install Firefox
- Pacman automatically installs all libraries Firefox needs
- If you remove those libraries, pacman warns you ("X depends on this!")

**Update process**:
```bash
sudo pacman -Syu
```
- Downloads latest package database
- Shows you what will be updated
- Updates everything at once
- Occasionally shows important messages (READ THEM!)

#### The AUR: Arch User Repository

**The problem**: Pacman only has "official" packages. What about niche software?

**The solution**: AUR—a community-maintained repository of build scripts.

**How it works**:

1. Someone writes a PKGBUILD file (build instructions)
2. Uploads to AUR
3. You download the PKGBUILD
4. Run `makepkg -si`
5. It downloads source code, compiles it, installs it

**Example: Installing an AUR package manually**
```bash
git clone https://aur.archlinux.org/package-name.git
cd package-name
makepkg -si  # Build and install
```

**AUR helpers** (tools that automate this):
- `yay` (most popular)
- `paru`

```bash
yay -S package-name  # Searches both official repos and AUR
```

**Why this matters**:
- Official repos: ~13,000 packages
- AUR: ~80,000+ packages
- Combined: Nearly everything you could want

**The risk**:
- AUR packages are USER-SUBMITTED
- Not vetted by Arch team
- Read the PKGBUILD before installing (could be malicious)
- The Arch Wiki warns: "Use at your own risk"

---

### The Arch Wiki: The Sacred Texts

**The Arch Wiki** = THE most comprehensive Linux documentation on the internet.

**URL**: https://wiki.archlinux.org

#### Why it's legendary:

- Covers EVERYTHING (installation, configuration, troubleshooting)
- Not just for Arch—useful for all Linux distros
- Written by users, maintained meticulously
- Often better than official documentation

**Examples of pages**:
- General recommendations (things to do after installation)
- List of applications (categorized by purpose)
- Specific hardware (Thinkpad tweaks, GPU configuration)
- Every major program (vim, systemd, GRUB, etc.)

**The Arch community's mantra**: "RTFM" (Read The Fantastic Manual)
- Ask a question → response: "Check the wiki"
- Because 99% of the time, it's already documented there

**Your workflow when learning Arch**:
1. Want to do X
2. Search wiki: "Arch wiki X"
3. Follow instructions
4. It works
5. You understand WHY it works

---

### Building Your Desktop: The Arch Way

After installation, you have a command prompt. Now what?

**You choose EVERYTHING**:

#### 1. Display Server
```bash
sudo pacman -S xorg-server  # X11 (older, stable)
# OR
sudo pacman -S wayland      # Wayland (newer, modern)
```

#### 2. Desktop Environment (or Window Manager)

**Desktop Environment** (full package—panel, file manager, settings, etc.):
```bash
sudo pacman -S gnome        # GNOME
sudo pacman -S plasma       # KDE Plasma
sudo pacman -S xfce4        # XFCE (lightweight)
```

**Window Manager** (minimal—just manages windows, you add everything else):
```bash
sudo pacman -S i3           # Tiling WM
sudo pacman -S bspwm        # Binary space partitioning WM
sudo pacman -S openbox      # Floating WM
```

#### 3. Display Manager (login screen)
```bash
sudo pacman -S sddm         # Simple Desktop Display Manager
sudo systemctl enable sddm  # Start at boot
```

#### 4. Applications (install ONLY what you need)
```bash
sudo pacman -S firefox       # Browser
sudo pacman -S alacritty     # Terminal
sudo pacman -S thunar        # File manager
sudo pacman -S vim           # Text editor
sudo pacman -S mpv           # Media player
```

**The beauty**: Your system has ONLY what you installed. No bloat.

**The challenge**: You need to know what you need.

---

### System Maintenance: Keeping Arch Healthy

#### 1. Regular Updates

**DO THIS REGULARLY** (at least once a week):
```bash
sudo pacman -Syu
```

**Why?**
- Arch moves fast—packages update frequently
- Waiting months → massive update → higher risk of breakage
- Small updates = safer

**Read the output!**
- Sometimes pacman shows warnings
- "Action required: Manual intervention needed"
- Check Arch news: https://archlinux.org/news/

#### 2. Clean Package Cache

**The problem**: Pacman keeps old package versions in `/var/cache/pacman/pkg/`
- After a year: Could be gigabytes of old packages

**The solution**:
```bash
sudo pacman -Sc  # Remove uninstalled packages from cache
sudo pacman -Scc # Remove ALL packages from cache (aggressive)
```

Or use `paccache`:
```bash
paccache -r      # Keep last 3 versions, remove older
paccache -rk1    # Keep only 1 version
```

#### 3. Remove Orphaned Packages

**Orphans** = packages that were installed as dependencies, but nothing needs them anymore

```bash
# List orphans
pacman -Qdt

# Remove orphans
sudo pacman -Rns $(pacman -Qdtq)
```

#### 4. Check for Failed Services

```bash
systemctl --failed  # Show services that failed to start
journalctl -p 3 -b  # Show errors from current boot
```

#### 5. Check Disk Space

```bash
df -h               # Check partition usage
du -sh ~/.cache/    # Check cache size
```

---

### Common Arch Commands Cheat Sheet

#### Package Management
```bash
# Update everything
sudo pacman -Syu

# Install package
sudo pacman -S package

# Remove package (keep dependencies)
sudo pacman -R package

# Remove package + dependencies + config files
sudo pacman -Rns package

# Search for package
pacman -Ss keyword

# Info about package
pacman -Si package  # from repo
pacman -Qi package  # installed

# List files in package
pacman -Ql package

# Find which package owns a file
pacman -Qo /path/to/file

# List explicitly installed packages
pacman -Qe
```

#### System Management
```bash
# Start/stop/restart service
sudo systemctl start servicename
sudo systemctl stop servicename
sudo systemctl restart servicename

# Enable service at boot
sudo systemctl enable servicename

# Check service status
systemctl status servicename

# View logs
journalctl -xe          # Recent errors
journalctl -u service   # Logs for specific service
journalctl -b           # Logs from current boot
```

#### Troubleshooting
```bash
# Check failed services
systemctl --failed

# Check disk space
df -h

# Check memory usage
free -h

# Check running processes
htop

# Test internet connection
ping archlinux.org

# Check DNS
cat /etc/resolv.conf
```

---

### Why People Choose Arch

#### Reasons to use Arch:

1. **Learn Linux deeply**
   - Installation teaches you how Linux works
   - You understand your system because you built it

2. **Total control**
   - No decisions made for you
   - No bloatware
   - Install ONLY what you need

3. **Rolling release**
   - Always latest software
   - Never reinstall

4. **The AUR**
   - Nearly every package imaginable
   - Community-maintained

5. **The Wiki**
   - Best Linux documentation anywhere
   - Learn from the best

6. **Performance**
   - Minimal base system
   - No unnecessary services running
   - Fast and lightweight

7. **Customization**
   - Build your desktop exactly how you want
   - From window manager to keybindings

8. **The community**
   - Active forums
   - Knowledgeable users
   - Culture of documentation and RTFM

---

### Why People DON'T Choose Arch

#### Reasons to avoid Arch:

1. **Steep learning curve**
   - Installation is complex
   - Assumes you know what you're doing
   - Not beginner-friendly

2. **Time investment**
   - Manual installation takes hours (first time)
   - Need to configure everything yourself
   - Troubleshooting requires research

3. **Potential instability**
   - Bleeding-edge = occasionally breaks
   - Need to pay attention to updates
   - Not ideal for critical systems

4. **Manual intervention sometimes required**
   - Updates occasionally need manual fixes
   - Arch news = required reading
   - Can't just blindly update

5. **Less corporate support**
   - No paid support option
   - Community-driven (help yourself via wiki/forums)

---

### Arch-Based Distros: The "Easy Arch" Options

Want Arch's benefits without the manual installation?

#### Manjaro
- Pre-configured Arch with GUI installer
- Slightly delayed updates (more stable)
- Beginner-friendly

#### EndeavourOS
- Arch with simple installer
- Closer to "pure Arch" than Manjaro
- Minimal pre-configuration

#### Garuda Linux
- Gaming-focused Arch variant
- Beautiful UI out of the box
- Performance tweaks pre-applied

**The tradeoff**: You lose the learning experience of manual installation, but you gain convenience.

---

### The Arch Initiation Ritual: Understanding the Meme

**The meme**: "I use Arch, btw"

**Why Arch users say this**:
- Installing Arch is a rite of passage
- Signals: "I understand Linux at a deep level"
- Badge of honor in Linux communities

**Is it elitism?** Sometimes, yes.

**Is it justified?** Kind of—installing Arch DOES teach you a ton.

**Should you care?** No. Use what works for you.

---

### Your Arch Journey: A Roadmap

#### Level 1: Pre-Arch (You are here)
- Learning Linux basics
- Using beginner-friendly distros (Ubuntu, Mint)
- Understanding terminal commands

#### Level 2: Arch-Curious
- Reading the Arch Wiki
- Understanding: partitions, bootloaders, filesystems
- Comfortable with the terminal

#### Level 3: First Arch Install
- Follow the installation guide EXACTLY
- Expect to fail and reinstall (normal!)
- Takes 2-4 hours first time
- Boot into command prompt = success

#### Level 4: Building Your Desktop
- Install Xorg/Wayland
- Choose desktop environment or window manager
- Install essential apps
- Configure everything

#### Level 5: Daily Driver
- Using Arch as main system
- Updating regularly
- Reading Arch news before updates
- Consulting wiki for everything

#### Level 6: Arch Master
- Custom configurations (dotfiles)
- Maintaining AUR packages
- Helping others on forums
- Saying "I use Arch, btw" (optional)

---

### The Practical Reality: Should YOU Use Arch?

**Use Arch if:**
- You want to deeply understand Linux
- You enjoy tinkering and customization
- You're willing to read documentation
- You have time for troubleshooting
- You want total control over your system

**DON'T use Arch if:**
- You need a stable work machine (use Ubuntu LTS)
- You don't want to learn command line
- You just want something that works (use Pop!_OS, Mint)
- You're brand new to Linux (start with Ubuntu/Mint, come to Arch later)

**The honest truth**: Arch is a learning tool disguised as an operating system.

You don't use Arch because it's "better"—you use Arch because building it teaches you how Linux works at a fundamental level.

---

### The Arch Linux Prayer

> "Lord, thank You for Judd Vinet who started Arch in 2002, and for Aaron Griffin who maintained it for years. Thank You for pacman, the AUR, and especially the Wiki—the sacred texts that guide us. Grant me patience during installation, wisdom to read the news before updating, and humility to RTFM before asking questions. May my system stay rolling, my packages stay updated, and my bootloader stay unbroken. And if I ever say 'I use Arch, btw,' let it be from knowledge, not arrogance. Amen."

---

### Final Wisdom

**The Arch philosophy is not about superiority—it's about transparency.**

Other distros hide complexity to make things easier. Arch exposes complexity to make things understandable.

**Both approaches are valid.**

Use Ubuntu if you want to get work done without thinking about the OS.

Use Arch if you want to understand the OS deeply.

**The cathedral of computing has many rooms. Arch Linux is the workshop where you see how the tools are made.**

Welcome to the workshop.

---