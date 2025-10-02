#!/usr/bin/env bash
set -euo pipefail

echo "=== NigelOS: Fix Realtek Bluetooth via Bootloader and Module Options ==="

need_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    echo "This script must run as root. Try: sudo $0" >&2
    exit 1
  fi
}

backup_file() {
  local f="$1"
  if [[ -f "$f" ]]; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    cp -n "$f" "${f}.backup_${ts}" || true
  fi
}

update_grub_cmdline() {
  local grub_file="/etc/default/grub"
  if [[ ! -f "$grub_file" ]]; then
    echo "[WARN] $grub_file not found. Are you using GRUB? Skipping GRUB edits." >&2
    return 0
  fi

  backup_file "$grub_file"

  local current
  current=$(grep -E '^GRUB_CMDLINE_LINUX_DEFAULT=' "$grub_file" | sed -E 's/^[^\"]*\"([^\"]*)\".*/\1/' || true)
  if [[ -z "$current" ]]; then
    echo "[WARN] Could not read GRUB_CMDLINE_LINUX_DEFAULT. Skipping." >&2
    return 0
  fi

  local params_to_add=(
    "reboot=efi"
    "btusb.reset=1"
    "btusb.enable_autosuspend=0"
  )

  local new="$current"
  for p in "${params_to_add[@]}"; do
    case " $new " in
      *" $p "*) : ;; # already present
      *) new="$new $p" ;;
    esac
  done
  # normalize spaces
  new=$(echo "$new" | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//')

  if [[ "$new" != "$current" ]]; then
    echo "[INFO] Updating GRUB_CMDLINE_LINUX_DEFAULT"
    echo "  Old: $current"
    echo "  New: $new"
    sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*\"|GRUB_CMDLINE_LINUX_DEFAULT=\"$new\"|" "$grub_file"
    if command -v grub-mkconfig >/dev/null 2>&1; then
      echo "[INFO] Regenerating GRUB configuration..."
      grub_mcfg_target="/boot/grub/grub.cfg"
      # On some distros, the path could differ; allow override
      [[ -n "${GRUB_CFG_OUT:-}" ]] && grub_mcfg_target="$GRUB_CFG_OUT"
      grub-mkconfig -o "$grub_mcfg_target"
    else
      echo "[WARN] grub-mkconfig not found; please regenerate your bootloader config manually." >&2
    fi
  else
    echo "[INFO] GRUB kernel parameters already include desired flags."
  fi
}

persist_btusb_options() {
  echo "[INFO] Ensuring persistent btusb module options..."
  mkdir -p /etc/modprobe.d
  local conf="/etc/modprobe.d/btusb.conf"
  if [[ ! -f "$conf" ]] || ! grep -Eq '^options[[:space:]]+btusb[[:space:]]+.*reset=1' "$conf"; then
    echo "options btusb reset=1 enable_autosuspend=0" > "$conf"
    echo "[INFO] Wrote $conf"
  else
    echo "[INFO] $conf already configured"
  fi
}

reload_bluetooth_stack() {
  echo "[INFO] Enabling bluetooth service..."
  systemctl enable --now bluetooth || true

  echo "[INFO] Unblocking rfkill..."
  rfkill unblock bluetooth || true

  echo "[INFO] Reloading Bluetooth kernel modules..."
  systemctl stop bluetooth || true
  modprobe -r btusb btrtl btintel btbcm btmtk 2>/dev/null || true
  modprobe btusb reset=1 enable_autosuspend=0 || true
  systemctl start bluetooth || true

  # Nudge USB power policy to keep the BT controller on
  local h usbdev d
  h=$(readlink -f /sys/class/bluetooth/hci0 2>/dev/null || true)
  if [[ -n "$h" ]]; then
    d=$(dirname "$h")
    while [[ "$d" != "/" && ! -f "$d/idVendor" ]]; do d=$(dirname "$d"); done
    if [[ -f "$d/idVendor" ]]; then
      usbdev="$d"
      [[ -w "$usbdev/power/control" ]] && echo on > "$usbdev/power/control" || true
      [[ -w "$usbdev/power/autosuspend" ]] && echo -1 > "$usbdev/power/autosuspend" || true
    fi
  fi
}

post_checks() {
  echo "\n=== Post-fix checks ==="
  echo "-- Kernel cmdline --"; cat /proc/cmdline || true
  echo "\n-- rfkill list --"; rfkill list || true
  echo "\n-- bluetoothctl show (may need a reboot) --"; bluetoothctl show || true
}

main() {
  need_root
  update_grub_cmdline
  persist_btusb_options
  reload_bluetooth_stack
  post_checks
  echo "\n[OK] Applied bootloader and module fixes for Bluetooth. A reboot is recommended."
}

main "$@"

