# Login Failure Investigation Report
**Date:** November 27, 2025
**System:** Linux (Arch/Hyprland)
**Issue:** Computer refusing to login after reboot

---

## Executive Summary

Your login issue has a **clear root cause**: the **xdg-desktop-portal-hyprland component crashes immediately after successful authentication**, preventing the desktop from loading. Authentication succeeds, but the session terminates before the desktop can initialize.

---

## Root Cause: xdg-desktop-portal-hyprland Segmentation Fault

**Primary Finding:** A SIGSEGV (Segmentation Fault) in the `xdg-desktop-portal-hyprland` component crashes the session immediately after login.

**Evidence:**
- **Crash Report:** `/home/nigel/.cache/drkonqi/crashes/xdg-desktop-portal-hyprland.bc0e542d3b0f4e39bcc42296f3a8e5f5.2649759.1759259977000000.ini`
- **Crash Type:** Signal 11 (SIGSEGV)
- **Location:** Wayland client library proxy destruction
- **Stack Trace:**
  ```
  #0  0x00007fa811995c01 in libwayland-client.so.0
  #1  0x00007fa811995d81 in libwayland-client.so.0
  #2  0x00007fa811997032 wl_proxy_destroy (libwayland-client.so.0)
  #3  0x0000562bd8d8769b in /usr/lib/xdg-desktop-portal-hyprland
  ```
- **When:** During desktop environment initialization at 23:02:29 (immediately after successful authentication)

**Impact:** The session starts, authentication passes, but the Wayland portal crashes before the desktop can fully load, terminating the session and sending you back to the login screen.

---

## Timeline of Events

| Time | Event | Status |
|------|-------|--------|
| 23:02:12 | Boot completes | ✓ Success |
| 23:02:19 | SDDM greeter starts | ✓ Success |
| 23:02:29 | Authentication succeeds for user "nigel" | ✓ **Success** |
| 23:02:29 | Hyprland Wayland session starts | ✓ Success |
| 23:02:29 | **xdg-desktop-portal-hyprland crashes** | ✗ **FAILURE** |
| 23:02:29 | Session terminated | ✗ Crash |

---

## Secondary Issues Detected

### 1. Corrupted /etc/hosts File
```
127.0.0.1localhost     # WRONG - missing space
::1       localhost
```

**Issue:** Line 3 should be `127.0.0.1 localhost` (with space)

**Symptom:** dnsmasq warning in logs: "bad address at /etc/hosts line 5"

**Impact:** Minor - causes DNS resolution warnings, not critical for login

---

### 2. Graphics Driver Issues (AMDGPU)
From Xorg logs:
```
[27.693] (WW) AMDGPU(0): flip queue failed: Invalid argument
[27.693] (WW) AMDGPU(0): Page flip failed: Invalid argument
sddm[820]: Could not setup default cursor
```

**Issue:** Page flip failures and cursor initialization problems

**Impact:** May affect display rendering but not direct cause of login failure

---

### 3. Missing Library Dependencies
The following libraries were not found:
- `libgepub-0.7.so.0` (GEPUB thumbnail support)
- `libopenrawgnome.so.9` (RAW image thumbnailer)
- `libffmpegthumbnailer.so.4` (video thumbnailer)
- `libcamera SPA plugin` (camera support)

**Impact:** Non-critical for login; affects media handling only

---

### 4. D-Bus Service Issues
```
dbus-broker-launch[855]: Ignoring duplicate name 'org.freedesktop.FileManager1'
Activation request for 'org.freedesktop.home1' failed
Activation request for 'org.freedesktop.resolve1' failed
```

**Issue:** D-Bus services misconfigured or missing duplicates

**Impact:** May cause application startup issues but not login blocking

---

### 5. GNOME Keyring Daemon Issue
```
gkr-pam: unable to locate daemon control file
```

**Issue:** gnome-keyring-daemon not properly initialized

**Impact:** Password/credential storage issues, not login blocking

---

### 6. Recent System Changes (from bash history)
Recent commands indicate modifications to:
- systemd mount configurations (`loader-efi.mount`)
- D-Bus broker service (enable/disable)
- systemd unit overrides with `ConditionPathExists`

**Impact:** These may have destabilized the system state, though they don't directly cause the xdg-portal crash.

---

## Recommended Fixes

### **Immediate (Critical) - Fix the Login Issue**

1. **Reinstall xdg-desktop-portal-hyprland** (the crashing component):
   ```bash
   sudo pacman -S --force xdg-desktop-portal-hyprland
   ```

2. **Reinstall Wayland client libraries**:
   ```bash
   sudo pacman -S --force libwayland
   ```

3. **Force rebuild if issue persists** (for AUR users):
   ```bash
   yay -S xdg-desktop-portal-hyprland --rebuild
   ```

### **Secondary (Important) - Fix Supporting Issues**

1. **Fix /etc/hosts file**:
   ```bash
   sudo nano /etc/hosts
   # Change line 3 from: 127.0.0.1localhost
   # To:                 127.0.0.1 localhost
   ```

2. **Reinstall missing thumbnailing libraries**:
   ```bash
   sudo pacman -S -u gvfs-nfs gvfs-mtp  # or similar thumbnail providers
   ```

3. **Verify gnome-keyring installation**:
   ```bash
   sudo pacman -S gnome-keyring
   ```

### **Tertiary (Optional) - Fallback Options**

If Wayland-based fixes don't work:

1. **Switch to X11 session** - At SDDM login screen, look for session selector (usually in corner) and switch to "Hyprland (X11)" or "KDE Plasma (X11)"

2. **Review recent systemd changes**:
   ```bash
   # Check for recent unit file modifications
   ls -lt /etc/systemd/system/

   # Revert problematic mount overrides if needed
   sudo systemctl daemon-reload
   ```

---

## Testing Steps to Verify Fix

After applying fixes:

1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **At SDDM login screen**, ensure:
   - You see the login prompt clearly
   - Keyboard input works

3. **Enter credentials** and observe:
   - Authentication message appears
   - Desktop environment starts loading
   - Desktop fully loads without crashing

4. **If successful**, verify:
   - Desktop is responsive
   - Applications launch
   - System is stable

---

## Key Takeaways

| Finding | Severity | Root Cause |
|---------|----------|-----------|
| xdg-desktop-portal-hyprland crash | **CRITICAL** | Wayland library issue, segmentation fault |
| /etc/hosts corruption | LOW | Configuration error, missing space |
| AMDGPU page flip failures | MEDIUM | Graphics driver/Wayland interaction |
| Missing libraries | LOW | Unrelated feature dependencies |
| D-Bus service issues | MEDIUM | Service configuration problems |

**The xdg-desktop-portal-hyprland crash is the smoking gun.** Fixing this component should restore your ability to login and use the desktop.

---

## Notes for Future Reference

- This type of issue is often related to Wayland/Hyprland updates that introduce binary incompatibilities
- The segmentation fault in libwayland-client suggests the portal component may have been built against an incompatible Wayland library version
- Consider monitoring AUR package updates for xdg-desktop-portal-hyprland if you maintain it from source
