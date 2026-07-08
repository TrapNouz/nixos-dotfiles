#!/usr/bin/env bash
set -e

# 1. Detect this machine's hardware and generate hardware-configuration.nix
nixos-generate-config --root /mnt

# 2. Clone your dotfiles repo into a temp folder
git clone https://github.com/TrapNouz/nixos-dotfiles.git /mnt/etc/nixos-tmp

# 3. Swap in the freshly-detected hardware config for this machine
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos-tmp/hardware-configuration.nix

# 4. Replace the auto-generated folder with your real config
rm -rf /mnt/etc/nixos
mv /mnt/etc/nixos-tmp /mnt/etc/nixos

# 5. Install using your flake's "nixos" host
nixos-install --flake "/mnt/etc/nixos#nixos"
