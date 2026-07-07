# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,nix-cachyos-kernel,inputs, ... }:

{

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];  
  config.common.default = "kde";
};

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  services.displayManager.sddm.thyx.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;



  boot.loader.limine = {
      enable = true;
      enableEditor = false;
      maxGenerations = 10;

      # FORCE WINDOWS AS THE FIRST CHOICE:
      # Entry 1 is NixOS (latest generation), Entry 2 is Windows 11.
      extraConfig = '' 
      default_entry: Windows 11
      timeout: 5
      '';

      # Native Secure Boot Layer
      enrollConfig = true;
      panicOnChecksumMismatch = true;
      secureBoot = {
        enable = true;
        autoGenerateKeys = true;
        autoEnrollKeys.enable = true;
      };

      # Dual-Boot Chainloading
      extraEntries = ''
        /Windows 11
        protocol: efi
       path: hdd(2:1):/EFI/Microsoft/Boot/bootmgfw.efi
      '';

      # Interface Styling
      style = {
        wallpapers = [ ./abstract-swirls.jpg ];
        wallpaperStyle = "stretched";
        interface = {
          branding = "Nathan's NixOS Machine";
          brandingColor = "5";
        };
      };
    };


  # Use latest kernel.
  boot.kernelPackages = nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = [ pkgs.kdePackages.konsole ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."trapnouz" = {
    isNormalUser = true;
    description = "TrapNouz";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };


  # Fish
  programs.fish = {
    enable = true;
  };


  # Fonts
  fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  ];

  # Nix build optimizations
  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0;
  nix.settings.substituters = [ "https://cache.nixos.org" "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
  ];

# Auto garbage collect weekly
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};

  # Wayland Cursor Fix
  environment.sessionVariables = {
    QSG_RHI_BACKEND = "opengl";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

# Home Manager
home-manager.users.trapnouz = import ./home.nix;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flatpak
  services.flatpak.enable = true;

  # Programs
  programs.steam.enable=true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   git
   pkgs.prismlauncher
   steam
   fastfetch
   pkgs.kitty
   wget
   unzip
   pkgs.obs-studio
   obsidian
   protonmail-desktop
   sbctl
   inputs.helium.packages.${pkgs.system}.default

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
