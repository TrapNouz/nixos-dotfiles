{ config, pkgs, lib, inputs, ... }:

{
  home.username = "trapnouz";
  home.homeDirectory = "/home/trapnouz";
  home.stateVersion = "26.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  imports = [
    # Import the Home Manager module provided by the flake
    inputs.nix-index-database.hmModules.nix-index
  ];

  # Enable nix-index with fast database and fish integration
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.nix-index-database.comma.enable = true; # Optional: gives you a super fast ',' command-not-found runner

  # Your dotfiles/packages managed by Home Manager
  home.packages = with pkgs; [
    rofi
    # add user packages here
  ];

  home.file = {
    ".config/rofi/config.rasi".source = ./rofi/config.rasi;
    ".config/rofi/catppuccin-mocha.rasi".source = ./rofi/catppuccin-mocha.rasi;
  };

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
      sdn = "shutdown now";
    };
    interactiveShellInit = "fastfetch;set fish_greeting";
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          top = 2;
          left = 2;
          right = 6;
        };
      };
      display = {
        separator = " ─── ";
        color = {
          keys = "magenta";
          title = "cyan";
        };
      };
      modules = [
        "title"
        {
          type = "custom";
          format = "┌────────────────────────────────────────┐";
          outputColor = "blue";
        }
        {
          type = "os";
          key = "  󱄅  OS     ";
          keyColor = "cyan";
        }
        {
          type = "kernel";
          key = "    Kernel ";
          keyColor = "cyan";
        }
        {
          type = "uptime";
          key = "  󱎫  Uptime ";
          keyColor = "cyan";
        }
        {
          type = "packages";
          key = "  󰏖  Pkgs   ";
          keyColor = "cyan";
        }
        {
          type = "shell";
          key = "  󰈺  Shell  ";
          keyColor = "cyan";
        }
        {
          type = "terminal";
          key = "    Term   ";
          keyColor = "cyan";
        }
        {
          type = "custom";
          format = "├────────────────────────────────────────┤";
          outputColor = "blue";
        }
        {
          type = "cpu";
          key = "    CPU    ";
          keyColor = "yellow";
        }
        {
          type = "gpu";
          key = "  󰢮  GPU    ";
          keyColor = "yellow";
        }
        {
          type = "memory";
          key = "    Memory ";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────┘";
          outputColor = "blue";
        }
        "break"
        "colors"
      ];
    };
  };

  # Fixes pinned taskbar icons breaking after Nix garbage collection
  home.activation.clean-plasma-launchers = "run sed -i 's|file:///nix/store/[^/]*/share/applications/|applications:|g' $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc || true";
}
