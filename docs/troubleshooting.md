# Troubleshooting Log

Brief record of system issues encountered and resolved.

## Bluetooth Configuration Chaos (2025-09-30)
**Problem:** Bluetooth stopped working after Plymouth/bootloader modifications
**Cause:** Configuration sprawl - multiple conflicting scripts and config files
**Fix:** Cleaned up duplicate configs, centralized to one systemd unit
**Lesson:** One fix at a time. Check before creating config files.

## Login Failure Investigation (2025-11-27)
**Problem:** Login failures on SDDM
**Fix:** [Brief description of resolution]
**Lesson:** [Key takeaway]

## Bootloader Configuration (2025-10-01)
**Problem:** Boot delay and configuration issues
**Fix:** Cleaned kernel parameters, simplified GRUB config
**Lesson:** Keep bootloader simple, document all kernel params

---

## Key Principles
1. **One fix at a time** - Don't pile changes
2. **Check before creating** - Avoid duplicate configs
3. **Document as you go** - Future you will thank you
4. **Know what's running** - `systemctl list-units`
5. **Nuclear option ready** - Keep backups for quick restore
