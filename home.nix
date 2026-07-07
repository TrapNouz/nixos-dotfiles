{ config, pkgs, lib, ... }:

{
  home.username = "trapnouz";
  home.homeDirectory = "/home/trapnouz";
  home.stateVersion = "26.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Your dotfiles/packages managed by Home Manager
  home.packages = with pkgs; [
    rofi
    # add user packages here
  ];


programs.vim = {
  enable = true;
  settings = {
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
  };
  extraConfig = ''
    set autoindent
    set smartindent
  '';
};
programs.kitty = {
  enable = true;

  font = {
    name = "JetBrainsMono Nerd Font";
    size = 11;
  };
  themeFile = "Catppuccin-Mocha";
};
programs.fish = {
    enable = true;
    shellAliases = {
      unx = "cd /home/trapnouz/.dotfiles && nix flake update && sudo nixos-rebuild switch --flake /home/trapnouz/.dotfiles#nixos && git add . && git commit -m 'rebuild: '(date +%Y-%m-%d) && git push";
      garbagenix = "nix-collect-garbage -d && sudo nix-collect-garbage -d && nix-store --optimise";
    };
    interactiveShellInit = "fastfetch;set fish_greeting";
  };

# Automatically suggests packages when you type a command that isn't installed
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Fixes pinned taskbar icons breaking after Nix garbage collection
  home.activation.clean-plasma-launchers = "run sed -i 's|file:///nix/store/[^/]*/share/applications/|applications:|g' $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc || true";
}
