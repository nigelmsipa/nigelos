# NigelOS Plymouth Bootloader Setup

## Overview
Custom Plymouth boot screen with pulsing blue circle animation for NigelOS.

## What Was Done

### 1. Created Plymouth Theme Files
Location: `/usr/share/plymouth/themes/nigelos/`

Files created:
- `nigelos.script` - Main animation script with pulsing circle
- `nigelos.plymouth` - Theme configuration file
- `circle.png` - Blue circle graphic (80x80px)

### 2. Theme Features
- Pulsing blue circle animation (scales from 1.0 to 1.1)
- "NIGEL OS" text with glow effect
- Rotating status messages:
  - INITIALIZING
  - LOADING KERNEL
  - STARTING SERVICES
  - PREPARING DESKTOP
  - WELCOME
- Version info in bottom-left corner

### 3. Installation Commands
```bash
# Create theme in temp directory
mkdir -p /tmp/nigelos-plymouth

# Create circle image
magick -size 80x80 xc:none -fill '#4d79ff' -draw "circle 40,40 40,0" /tmp/nigelos-plymouth/circle.png

# Copy theme files to system
sudo cp -r /tmp/nigelos-plymouth /usr/share/plymouth/themes/nigelos

# Set as default and rebuild initramfs
sudo plymouth-set-default-theme -R nigelos
```

## Troubleshooting

### Revert to Default Theme
```bash
# List available themes
plymouth-set-default-theme --list

# Set back to default (usually bgrt or spinner)
sudo plymouth-set-default-theme -R bgrt

# Or try spinner
sudo plymouth-set-default-theme -R spinner
```

### Test Theme Without Rebooting
```bash
# Preview theme (requires switching to TTY)
sudo plymouthd
sudo plymouth --show-splash
# Wait a few seconds
sudo plymouth --quit
```

### Rebuild Initramfs Manually
```bash
sudo mkinitcpio -P
```

### Check Current Theme
```bash
plymouth-set-default-theme
```

### View Theme Files
```bash
ls -la /usr/share/plymouth/themes/nigelos/
cat /usr/share/plymouth/themes/nigelos/nigelos.plymouth
```

## Files Location
- Theme directory: `/usr/share/plymouth/themes/nigelos/`
- Source files (temp): `/tmp/nigelos-plymouth/`
- HTML mockup: `/home/nigel/index.html`

## Notes
- The `-R` flag in `plymouth-set-default-theme` automatically rebuilds initramfs
- Theme uses script-based animation for smooth pulsing effect
- Background is dark gradient (#1a1a1a to #0d0d0d)
- Circle color: #4d79ff (blue)

## Minimum Display Time Fix (3 Second Delay)

### Problem
The Plymouth splash screen was not displaying for at least 3 seconds as requested.

### Solution
Added `plymouth.force-delay=3` kernel parameter to force minimum 3-second display time.

### Commands
```bash
# Edit GRUB config to add plymouth.force-delay=3
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 plymouth.force-delay=3"/' /etc/default/grub

# Rebuild GRUB configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Reboot to test
reboot
```

### What Changed
- `/etc/default/grub` line 6 now includes `plymouth.force-delay=3`
- This ensures Plymouth splash screen displays for minimum 3 seconds before boot continues

### ACTUAL FIX: Systemd Plymouth Quit Delay (The Real Solution)

**Problem**: The `plymouth.force-delay=3` kernel parameter and `MinimumTime=3` in the Plymouth config don't actually work. Modern systems boot so fast that systemd terminates Plymouth almost immediately, causing the splash screen to flash for only a split second.

**Root Cause**: The `plymouth-quit.service` terminates Plymouth as soon as systemd reaches the display-manager target, which happens within milliseconds on fast systems. The kernel parameter doesn't prevent this.

**Solution**: Create a systemd service drop-in that delays `plymouth-quit.service` for 3 seconds **ONLY ON BOOT** (not shutdown) using a conditional check for `/run/systemd/shutdown`.

**Implementation**:
```bash
# Create drop-in directory
sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d

# Create delay configuration (boot-only, not shutdown)
echo '[Unit]
After=systemd-user-sessions.service

[Service]
ExecStartPre=/bin/sh -c '\''[ -e /run/systemd/shutdown ] || /bin/sleep 3'\''' | sudo tee /etc/systemd/system/plymouth-quit.service.d/delay.conf

# Reload systemd to apply changes
sudo systemctl daemon-reload

# Reboot to test
reboot
```

**Why This Works**:
- `ExecStartPre` runs before Plymouth quits, adding a mandatory 3-second delay **only on boot**
- The conditional `[ -e /run/systemd/shutdown ] ||` skips the delay during shutdown/reboot
- The delay happens in the systemd service lifecycle, not the kernel
- Plymouth continues to animate during this 3-second window
- This is the only reliable method to enforce minimum display time on fast-booting systems

**Files Modified**:
- `/etc/systemd/system/plymouth-quit.service.d/delay.conf` (created)

**Note**: This is more reliable than kernel parameters because it directly controls when systemd is allowed to terminate the Plymouth process.

## Side Effects and Issues Encountered

### Locale Breakage Breaking Rofi
**Problem**: After implementing Plymouth bootloader changes, rofi stopped launching from keybindings (ALT+Space, ALT+Return). Manual execution showed `Failed to set locale` error.

**Root Cause**: The `/etc/locale.gen` file had `en_US.UTF-8 UTF-8` commented out, causing locale generation to fail. This broke rofi's ability to launch via Hyprland keybindings.

**Symptoms**:
- `locale` command shows: `Cannot set LC_MESSAGES to default locale: No such file or directory`
- Rofi launches manually but not from keybindings
- Rofi displays warning: `Failed to set locale`

**Fix**:
```bash
# Uncomment en_US.UTF-8 in locale.gen
sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

# Regenerate locales
sudo locale-gen
```

**Why This Happened**: System modifications during bootloader setup likely regenerated or reset `/etc/locale.gen`, commenting out active locales.

### Bluetooth Issues
**Problem**: Bluetooth controller not powering on automatically after bootloader modifications.

**Root Cause**: `/etc/bluetooth/main.conf` had `AutoEnable=true` commented out, preventing Bluetooth from starting automatically on boot.

**Symptoms**:
- `bluetoothctl show` shows `Powered: no`
- `rfkill list` may show Bluetooth as soft-blocked
- Bluetooth devices not connecting automatically

**Fix**:
```bash
# Enable AutoEnable in Bluetooth config
sudo sed -i '353s/^#AutoEnable=true/AutoEnable=true/' /etc/bluetooth/main.conf

# Enable and start Bluetooth service
sudo systemctl enable --now bluetooth

# Unblock Bluetooth and reload driver
rfkill unblock bluetooth
sudo modprobe -r btusb && sudo modprobe btusb

# Verify
bluetoothctl show
```

**Files Modified**:
- `/etc/bluetooth/main.conf` line 353: `AutoEnable=true` (uncommented)

**Note**: System-level changes (like initramfs rebuilds, GRUB updates, or systemd modifications) can have cascading effects on seemingly unrelated components. Always verify core system functionality after bootloader changes.

### Reboot Powers Off Instead of Restarting
**Problem**: Running `reboot` command powers off the system completely instead of restarting.

**Root Cause**: Some firmware/motherboard combinations misinterpret the ACPI reboot signal and treat it as a shutdown command.

**Fix**:
```bash
# Add reboot=efi kernel parameter to force EFI reboot method
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&reboot=efi /' /etc/default/grub

# Rebuild GRUB configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Test with reboot
reboot
```

**Files Modified**:
- `/etc/default/grub`: Added `reboot=efi` to `GRUB_CMDLINE_LINUX_DEFAULT`

**Alternative Methods** (if `reboot=efi` doesn't work):
- `reboot=bios` - Use BIOS reboot method
- `reboot=acpi` - Use ACPI reboot method (default)
- `reboot=kbd` - Use keyboard controller for reboot

## Plymouth Script Layout Fix (Gray Text Under Logo)

**Problem**: Status text and version text were not properly positioned under the "NIGEL OS" logo, causing layout issues.

**Solution**: Updated `/usr/share/plymouth/themes/nigelos/nigelos.script` to correctly calculate Y positions relative to the logo height.

**Key Changes**:
- Status text positioned at `nigelos_y + nigelos_text.GetHeight() + 10`
- Version text positioned at `status_y + status_text.GetHeight() + 8`
- Dynamic repositioning when status messages change

**Implementation**:
```bash
# Backup original script
sudo cp /usr/share/plymouth/themes/nigelos/nigelos.script /usr/share/plymouth/themes/nigelos/nigelos.script.backup

# Replace with updated script (see full script in /tmp/nigelos.script)
sudo cp /tmp/nigelos.script /usr/share/plymouth/themes/nigelos/nigelos.script

# Rebuild initramfs
sudo plymouth-set-default-theme -R nigelos
```

**Files Modified**:
- `/usr/share/plymouth/themes/nigelos/nigelos.script`

## Quick Fix Script

All fixes combined in one script: `/tmp/fix_boot_bt.sh`

```bash
#!/bin/bash
set -e

echo "=== Backing up and replacing Plymouth script ==="
sudo cp /usr/share/plymouth/themes/nigelos/nigelos.script /usr/share/plymouth/themes/nigelos/nigelos.script.backup
sudo cp /tmp/nigelos.script /usr/share/plymouth/themes/nigelos/nigelos.script
sudo plymouth-set-default-theme -R nigelos

echo "=== Creating systemd drop-in for boot-only delay ==="
sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d
sudo cp /tmp/delay.conf /etc/systemd/system/plymouth-quit.service.d/delay.conf
sudo systemctl daemon-reload

echo "=== Configuring Bluetooth AutoEnable ==="
sudo sed -i '353s/^#AutoEnable=true/AutoEnable=true/' /etc/bluetooth/main.conf
sudo systemctl enable --now bluetooth
rfkill unblock bluetooth
sudo modprobe -r btusb && sudo modprobe btusb

echo "=== Testing Plymouth splash ==="
sudo plymouthd && sudo plymouth --show-splash && sleep 3 && sudo plymouth --quit

echo "=== Bluetooth status ==="
bluetoothctl show

echo "=== Done! Reboot to test. If reboot powers off, run: ==="
echo "sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"/&reboot=efi /' /etc/default/grub"
echo "sudo grub-mkconfig -o /boot/grub/grub.cfg"
```

## Lesson Learned
When modifying boot-critical components:
1. Always check locale settings after initramfs rebuild
2. Test Bluetooth functionality
3. Verify GUI application launchers (rofi, wofi, etc.) work correctly
4. Test reboot vs shutdown behavior
5. Verify Plymouth splash displays correctly with proper timing
6. Document all side effects for future reference

## Bootloader-Based Bluetooth Fix (Realtek/USB)

Context: Some USB Bluetooth adapters (e.g., Realtek `13d3:3549`) may fail to power or initialize reliably after changes to boot flow. Stabilizing at the bootloader and driver level fixes warm-boot and autosuspend issues.

What we add:
- GRUB kernel params: `reboot=efi btusb.reset=1 btusb.enable_autosuspend=0`
- Persistent module options: `options btusb reset=1 enable_autosuspend=0`

One-shot (recommended):
```bash
sudo bash nigelos/scripts/fix-bluetooth-bootloader.sh
sudo reboot
```

Manual steps:
```bash
# 1) Backup
sudo cp /etc/default/grub /etc/default/grub.backup_$(date +%Y%m%d%H%M%S)

# 2) Append kernel parameters
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 reboot=efi btusb.reset=1 btusb.enable_autosuspend=0"/' /etc/default/grub

# 3) Rebuild GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 4) Persist btusb options
echo 'options btusb reset=1 enable_autosuspend=0' | sudo tee /etc/modprobe.d/btusb.conf >/dev/null

# 5) Optional: Reload stack now (kernel params take effect after reboot)
sudo systemctl stop bluetooth || true
sudo rfkill unblock bluetooth || true
sudo modprobe -r btusb btrtl btintel btbcm btmtk 2>/dev/null || true
sudo modprobe btusb reset=1 enable_autosuspend=0
sudo systemctl start bluetooth || true

# 6) Reboot to apply kernel parameters
sudo reboot
```

Verify after reboot:
```bash
grep -Eo 'reboot=efi|btusb.reset=1|btusb.enable_autosuspend=0' /proc/cmdline
rfkill list
bluetoothctl show   # Expect: Powered: yes
```

If still flaky (optional stronger tweak):
```bash
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&usbcore.autosuspend=-1 /' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

Optional: keep BT USB from suspending via udev (replace IDs as needed):
```bash
cat <<'RULE' | sudo tee /etc/udev/rules.d/99-bt-usb-power.rules >/dev/null
SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3549", \
  TEST=="power/control", ATTR{power/control}="on", \
  TEST=="power/autosuspend", ATTR{power/autosuspend}="-1"
RULE
sudo udevadm control --reload && sudo udevadm trigger
```

TLP users: allowlist the adapter to avoid autosuspend
```bash
# /etc/tlp.conf
USB_DENYLIST=13d3:3549
sudo systemctl restart tlp
```

Rollback:
- Remove added params from `/etc/default/grub` and run `sudo grub-mkconfig -o /boot/grub/grub.cfg`.
- Delete `/etc/modprobe.d/btusb.conf` (or the line) and reboot.

## GRUB Menu Configuration (Hidden Menu)

**Date**: 2025-09-30

**Goal**: Configure GRUB to show a hidden menu that boots immediately but can be accessed with ESC/SHIFT.

**Changes Made**:
```bash
# Set timeout to 1 second
GRUB_TIMEOUT=1

# Set timeout style to hidden (press ESC/SHIFT to access menu)
GRUB_TIMEOUT_STYLE=hidden

# Rebuild GRUB configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Files Modified**:
- `/etc/default/grub` - Changed `GRUB_TIMEOUT=5` to `GRUB_TIMEOUT=1`
- `/etc/default/grub` - Changed `GRUB_TIMEOUT_STYLE=menu` to `GRUB_TIMEOUT_STYLE=hidden`

**Current Kernel Parameters** (as of 2025-09-30):
```
quiet splash loglevel=3 plymouth.force-delay=3 reboot=efi btusb.reset=1 btusb.enable_autosuspend=0
```

**Result**: GRUB menu is hidden by default, boots immediately after 1 second. Press ESC or SHIFT during boot to access the menu if needed.

## Second Plymouth Attempt - 2025-10-01 (METHODICAL APPROACH)

**Goal:** Install custom Plymouth splash screen with Easter eggs (3-second display) WITHOUT breaking Bluetooth

**Lesson Learned:** Last time we broke Bluetooth due to configuration sprawl. This time: ONE CHANGE AT A TIME with full tracking.

### Pre-Installation Baseline (CRITICAL)
- **Bluetooth:** hci0 ✅ (NOT hci6)
- **Hardware:** IMC Networks RTL8822CU (13d3:3549)
- **Status:** Powered: yes, Working perfectly
- **Kernel Params:** `quiet splash reboot=efi btusb.reset=1 btusb.enable_autosuspend=0 usbcore.autosuspend=-1`
- **Backup Created:** `/tmp/grub.backup.20251001`

### Plymouth Theme Design
**Visual Elements:**
- Pulsating blue circle (#4d79ff) - scales 1.0 to 1.1
- "NIGEL OS" logo text with glow
- Rotating status messages (600ms intervals)
- Dark gradient background (#1a1a1a → #0d0d0d)

**Easter Eggs (Finity Philosophy):**
- Status messages include:
  - "BOUNDARIES CREATE CLARITY"
  - "FUNCTION BEFORE FLOURISH"
  - "LESS BUT LASTING"
  - "THE JOY OF ENOUGH"
  - "ZERO FRUSTRATION AHEAD"
  - "GPU ACCELERATION CONFIRMED"

**Bottom-left info:**
```
v1.0 | Finity Edition
Hyprland • RX 6600 • Alt+I Ready
15,274 chunks • 75+ tok/s
```

**Bottom-right quote:**
```
"Only what we need,
nothing more."
— Finity Design System
```

### Installation Steps Completed

**Step 1:** ✅ Documented baseline Bluetooth state (hci0)
**Step 2:** ✅ Backed up `/etc/default/grub` to `/tmp/grub.backup.20251001`
**Step 3:** ✅ Created Plymouth theme files:
- `/tmp/nigelos-plymouth/nigelos.script` (4.1K) - Animation logic
- `/tmp/nigelos-plymouth/nigelos.plymouth` (236 bytes) - Theme config
- `/tmp/nigelos-plymouth/circle.png` (775 bytes) - Blue circle graphic

**Step 4:** ✅ Copied theme to `/usr/share/plymouth/themes/nigelos/`
**Step 5:** ✅ Verified Bluetooth still hci0 after file copy
**Step 6:** ✅ Set Plymouth as default: `sudo plymouth-set-default-theme -R nigelos`
  - Initramfs rebuild completed successfully
  - No errors during build
  - Plymouth hook loaded in initramfs

**Step 7:** ⏳ **ABOUT TO REBOOT** - Testing if Bluetooth survives initramfs rebuild

### Next Steps After Reboot

**SUCCESS CRITERIA:**
```bash
rfkill list bluetooth  # Should show: 0: hci0: Bluetooth
bluetoothctl show      # Should show: Powered: yes
```

**If Bluetooth is hci0:** ✅ Proceed to add 3-second delay
**If Bluetooth is hci6:** ❌ STOP, rollback immediately

### Rollback Procedure (If Bluetooth Breaks)

```bash
# 1. Restore GRUB config
sudo cp /tmp/grub.backup.20251001 /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 2. Remove Plymouth theme
sudo plymouth-set-default-theme -R bgrt

# 3. Reboot and verify Bluetooth returns to hci0
sudo reboot
```

### Files Created This Session
- `/tmp/nigelos-plymouth/` - Theme source files
- `/tmp/nigelos-splash-preview.html` - HTML preview (for testing design)
- `/tmp/nigelos-plymouth-install-log.md` - Detailed installation log
- `/usr/share/plymouth/themes/nigelos/` - Installed theme

**STATUS:** Waiting for reboot test to verify Bluetooth enumeration.
