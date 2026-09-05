# A1502 Snapshot

Point-in-time backup of this MacBook A1502's configuration, kept so the setup
can be restored (or referenced) after hardware/OS changes.

## History

- **2026-04-28** — snapshot taken before gifting the machine (CachyOS + niri).
- **2026-09-05** — refreshed before a battery replacement and a planned
  switch to Omarchy. Updated configs, added `pacman-explicit.txt` (explicit
  package list — useful since Omarchy is also Arch-based) and picked up
  dirs that didn't exist in April: `cachyos`, `noctalia`, `systemd` (user
  services — swww-daemon, wallpaper-cycle, pipewire-cleanup — see
  [[project-pipewire]] fix), and `autostart/fix-pipewire.desktop`.

## What's in here

- `config/` — mirrors the relevant subset of `~/.config` (desktop/shell/app
  configs only — nothing with credentials or large caches).
- Top-level dotfiles (`.zshrc`, `.bashrc`, `.gitconfig`, etc.) as of the
  snapshot date.
- `pacman-explicit.txt` — `pacman -Qqe` output, i.e. explicitly installed
  packages (not dependencies), for rebuilding the package set elsewhere.

## Deliberately excluded

`gh` (has an OAuth token in `hosts.yml`), `devin`, browser profiles
(`chromium`, `google-chrome-for-testing`, `seraph-chromium-profile`),
`Paper` (157MB of personal notes), `pulse`/`dconf` (runtime state, not config).

## Restoring

There's no automated restore script for this snapshot specifically — copy
the relevant `config/*` subdirs into `~/.config/` on the target machine, and
`pacman -S --needed -` < `pacman-explicit.txt` for packages.
