# BLUETOOTH BROKE AFTER PLYMOUTH/BOOTLOADER SETUP - ROOT CAUSE ANALYSIS

## THE TIMELINE OF DESTRUCTION

### What Worked BEFORE:
- Bluetooth functional (presumably as hci0)
- Normal boot process
- Standard GRUB configuration

### What You Did (The Trigger):
1. Created custom Plymouth theme (`/usr/share/plymouth/themes/nigelos/`)
2. Set Plymouth as default: `sudo plymouth-set-default-theme -R nigelos`
3. **CRITICAL**: `-R` flag rebuilds initramfs automatically
4. Modified GRUB kernel parameters multiple times:
   - Added `plymouth.force-delay=3`
   - Added `reboot=efi` (to fix reboot→shutdown issue)
   - Added bluetooth fixes: `btusb.reset=1 btusb.enable_autosuspend=0 usbcore.autosuspend=-1`
5. Multiple `sudo grub-mkconfig -o /boot/grub/grub.cfg` executions
6. Multiple `sudo mkinitcpio -P` rebuilds
7. Created systemd drop-in: `/etc/systemd/system/plymouth-quit.service.d/delay.conf`

### What Broke AFTER:
- Bluetooth controller enumerated as **hci6** (not hci0)
- "No default controller available"
- "Invalid Index (0x11)" errors
- Locale issues (fixed)
- Reboot→shutdown issue (fixed)
- **Bluetooth still broken despite 10+ attempted fixes**

## CURRENT STATUS (2025-09-30)

### Hardware:
- **Device**: IMC Networks Bluetooth Radio (USB ID: `13d3:3549`)
- **Chipset**: Realtek (uses btrtl module)
- **Interface**: hci6 (NOT hci0 - **critical anomaly**)
- **rfkill status**: Not blocked (soft/hard both = no)

### Software:
- **OS**: Arch Linux, Kernel 6.16.8-arch3-1
- **Bootloader**: GRUB 2.13 (UEFI mode)
- **BlueZ**: 5.84
- **Firmware**: linux-firmware-atheros 20250917-1

### Current GRUB Configuration:
File: `/etc/default/grub`
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_TIMEOUT=5
```

**NOTE**: User just stripped all kernel parameters back to bare minimum (`quiet` only). Previous parameters were:
```
quiet splash reboot=efi btusb.reset=1 btusb.enable_autosuspend=0 usbcore.autosuspend=-1
```

### Errors in Logs:
```
bluetoothd[561]: Failed to add UUID: Authentication Failed (0x05)
bluetoothd[561]: Failed to add UUID: Invalid Index (0x11)
bluetoothd[561]: Failed to set mode: Authentication Failed (0x05)
bluetoothd[561]: Failed to set mode: Invalid Index (0x11)
```

### Symptoms:
- `bluetoothctl show` → "No default controller available"
- `rfkill list` → Shows hci6 (not blocked)
- Service running but endpoints continuously register/unregister (10-second cycle)
- Modules loaded: btusb, btrtl, btintel, btbcm, bluetooth

## THE SMOKING GUN HYPOTHESES

### Hypothesis 1: **initramfs Module Load Order Corruption**
**Theory**: Plymouth theme installation + initramfs rebuild changed the order bluetooth modules load, causing hci6 enumeration instead of hci0.

**Test**:
```bash
# Check current initramfs hooks
grep "^HOOKS=" /etc/mkinitcpio.conf

# Look for plymouth hook interfering with bluetooth
lsinitcpio /boot/initramfs-linux.img | grep -E "plymouth|bluetooth|btusb"

# Check if bluetooth modules are in early initramfs
lsinitcpio /boot/initramfs-linux.img | grep "\.ko" | grep bt
```

---

### Hypothesis 2: **GRUB EFI Runtime Services Breaking USB Enumeration**
**Theory**: Adding `reboot=efi` changed how GRUB interacts with EFI runtime services, breaking USB device enumeration at boot time. Bluetooth now gets assigned wrong controller index.

**Status**: User stripped `reboot=efi` from GRUB config. **REBOOT NEEDED TO TEST**.

---

### Hypothesis 3: **systemd Plymouth Drop-in Breaking Boot Timing**
**Theory**: The `/etc/systemd/system/plymouth-quit.service.d/delay.conf` delays Plymouth quit by 3 seconds, which delays when systemd initializes bluetooth service. This timing change causes bluetooth to enumerate after other (phantom?) devices.

**Test**:
```bash
# Temporarily disable Plymouth delay
sudo mv /etc/systemd/system/plymouth-quit.service.d/delay.conf /etc/systemd/system/plymouth-quit.service.d/delay.conf.disabled
sudo systemctl daemon-reload
sudo reboot
```

---

### Hypothesis 4: **Kernel Parameter Accumulation Side Effects**
**Theory**: The combination of ALL kernel parameters together creates unexpected behavior.

**Status**: User stripped parameters to `quiet` only. **REBOOT NEEDED TO TEST**.

---

### Hypothesis 5: **mkinitcpio Hooks Added by Plymouth Interfering**
**Theory**: Plymouth installation added hooks to `/etc/mkinitcpio.conf` that conflict with bluetooth module loading in initramfs.

**Test**:
```bash
# Check if plymouth hook exists
grep plymouth /etc/mkinitcpio.conf

# Read current hooks
cat /etc/mkinitcpio.conf | grep "^HOOKS="

# Temporarily remove plymouth hook
sudo sed -i 's/ plymouth//' /etc/mkinitcpio.conf
sudo mkinitcpio -P
sudo reboot
```

---

### Hypothesis 6: **EFI Variable Namespace Collision**
**Theory**: GRUB modifications wrote EFI variables that collide with bluetooth firmware's NVS (non-volatile storage), corrupting pairing data or controller configuration.

**Test**:
```bash
# List bluetooth-related EFI variables (need sudo)
sudo ls -la /sys/firmware/efi/efivars/ | grep -i "bluetooth\|bt\|13d3"

# Check for corrupted bluetooth pairing data
sudo ls -la /var/lib/bluetooth/
```

---

## CRITICAL FILES TO CHECK AFTER REBOOT

### Verification Commands:
```bash
# 1. Check if bluetooth is now hci0
rfkill list
bluetoothctl show

# 2. Check actual kernel parameters loaded
cat /proc/cmdline

# 3. Check for bluetooth errors in boot log
journalctl -b | grep -E "bluetooth|btusb|hci" | head -100

# 4. Check if controller index changed
ls -la /sys/class/bluetooth/

# 5. Verify modules loaded
lsmod | grep -E "bluetooth|btusb"

# 6. Check USB device still detected
lsusb | grep -i bluetooth

# 7. Check systemd service status
systemctl status bluetooth
```

## FIXES ALREADY ATTEMPTED (ALL FAILED)

### Module-level fixes:
- ✗ `btusb.reset=1` kernel parameter
- ✗ `btusb.enable_autosuspend=0` kernel parameter
- ✗ `usbcore.autosuspend=-1` (global USB autosuspend disable)
- ✗ `/etc/modprobe.d/btusb.conf` with reset and autosuspend options
- ✗ Udev rule to force USB power management off for 13d3:3549
- ✗ Module reload (`modprobe -r btusb && modprobe btusb`)

### Service-level fixes:
- ✗ `AutoEnable=true` in `/etc/bluetooth/main.conf` (line 353)
- ✗ `systemctl enable --now bluetooth`
- ✗ `rfkill unblock bluetooth`

### Files Created During Troubleshooting:
- `/etc/modules-load.d/bluetooth.conf` - Ensures bluetooth/btusb modules load at boot
- `/etc/modprobe.d/btusb.conf` - Module options (may still exist)
- `/etc/udev/rules.d/99-bt-usb-power.rules` - USB power management (may exist)

## THE NUCLEAR ROLLBACK TEST

**If nothing else works, systematically undo everything**:

```bash
# 1. Remove Plymouth entirely
sudo plymouth-set-default-theme -R bgrt  # or spinner
sudo rm -rf /usr/share/plymouth/themes/nigelos/

# 2. Remove systemd drop-in
sudo rm -rf /etc/systemd/system/plymouth-quit.service.d/
sudo systemctl daemon-reload

# 3. GRUB already stripped to bare minimum - rebuild GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 4. Remove bluetooth module configs
sudo rm -f /etc/modprobe.d/btusb.conf
sudo rm -f /etc/udev/rules.d/99-bt-usb-power.rules

# 5. Remove modules-load.d config
sudo rm -f /etc/modules-load.d/bluetooth.conf

# 6. Check mkinitcpio for plymouth hooks
cat /etc/mkinitcpio.conf | grep "^HOOKS="

# 7. Rebuild initramfs clean
sudo mkinitcpio -P

# 8. Reboot and test
sudo reboot
```

## NEXT STEPS AFTER REBOOT

### If bluetooth WORKS (hci0 detected):
- Stripped kernel parameters fixed it
- Start adding parameters back one-by-one to find culprit:
  1. Add `splash` → test
  2. Add `reboot=efi` → test
  3. Add `btusb.reset=1` → test
  4. etc.

### If bluetooth STILL BROKEN (hci6, no controller):
- Try Hypothesis 3: Disable Plymouth delay drop-in
- Try Hypothesis 5: Remove plymouth hook from mkinitcpio.conf
- Try Hypothesis 6: Check EFI variables for corruption
- Try Nuclear Rollback: Remove Plymouth completely

### If bluetooth WORSE (no hci device at all):
- Kernel parameters were actually helping
- Restore previous GRUB config from backup
- Focus on hardware/firmware issues

## THE CORE MYSTERY

**Why hci6 instead of hci0?**
- No other bluetooth controllers physically exist
- No other hci* devices show in rfkill or system
- BlueZ expects hci0 as default controller
- "Invalid Index (0x11)" suggests BlueZ thinks there are 17+ controllers
- This anomaly appeared RIGHT AFTER Plymouth/initramfs changes

## RESEARCH QUESTIONS

### Arch-Specific:
1. "plymouth broke bluetooth arch linux"
2. "mkinitcpio bluetooth hci6 instead of hci0"
3. "bluetooth controller wrong index after initramfs rebuild"
4. "plymouth hook conflicts with btusb"

### Kernel-Specific:
5. "reboot=efi breaks usb bluetooth enumeration"
6. "btusb.reset=1 causes wrong hci index"
7. "usbcore.autosuspend bluetooth enumeration order"

### systemd-Specific:
8. "plymouth-quit.service delay breaks bluetooth"
9. "systemd bluetooth service timing race condition"
10. "bluetooth.service starts before usb enumeration complete"

## FILES REFERENCE

### Config Files:
- `/etc/default/grub` - GRUB configuration (currently stripped to `quiet` only)
- `/etc/mkinitcpio.conf` - Initramfs configuration (check HOOKS line)
- `/etc/bluetooth/main.conf` - BlueZ configuration (AutoEnable=true on line 353)
- `/etc/modules-load.d/bluetooth.conf` - Module autoload config

### System Files:
- `/usr/share/plymouth/themes/nigelos/` - Custom Plymouth theme
- `/etc/systemd/system/plymouth-quit.service.d/delay.conf` - 3-second delay
- `/boot/grub/grub.cfg` - Generated GRUB config (needs rebuild after /etc/default/grub changes)

### Diagnostic Locations:
- `/sys/class/bluetooth/` - Bluetooth controllers
- `/sys/firmware/efi/efivars/` - EFI variables (need sudo)
- `/var/lib/bluetooth/` - Bluetooth pairing data (need sudo)
- `/proc/cmdline` - Active kernel parameters

---

**Status**: GRUB config stripped to bare minimum. AWAITING REBOOT TEST to see if bluetooth works as hci0.
