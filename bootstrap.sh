#!/usr/bin/env bash
set -e

# 1. Detect this machine's hardware and generate hardware-configuration.nix
nixos-generate-config --root /mnt

# 2. Clone your dotfiles repo directly into trapnouz's home folder
git clone https://github.com/TrapNouz/nixos-dotfiles.git /mnt/home/trapnouz/.dotfiles

# 3. Swap in the freshly-detected hardware config for this machine
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/trapnouz/.dotfiles/hardware-configuration.nix

# 4. Clean up the temporary auto-generated folder (no longer needed)
rm -rf /mnt/etc/nixos

# 5. Install using the flake directly from ~/.dotfiles
nixos-install --flake "/mnt/home/trapnouz/.dotfiles#nixos"
