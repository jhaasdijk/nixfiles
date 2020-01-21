
# nixos https://nixos.org/channels/nixos-19.09
# unstable packages can be pulled by prepending 'unstable.' to pkgname

{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./configuration
    ./overlays
  ];

  nixpkgs.config = {
    # Allow proprietary packages.
    allowUnfree = true;

    # Enable unstableTarball.
    packageOverrides = pkgs: with pkgs; {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [

      # Browser
      firefox

      # Cli
      arandr dunst exa exfat fd gitAndTools.gitFull gnupg htop magic-wormhole
      p7zip powertop protonvpn-cli ranger ripgrep st tmux tree unzip xclip

      # Editor
      libreoffice neovim

      # Email
      thunderbird unstable.protonmail-bridge

      # IM client
      signal-desktop

      # Text formatting (LaTeX / Markdown)
      biber haskellPackages.pandoc-citeproc pandoc texlive.combined.scheme-full

      # Media (- Control)
      feh flameshot gimp libsForQt5.vlc pavucontrol poppler_utils qbittorrent
      sxiv zathura

      # Programming
      python3

    ];

    variables = {
      "EDITOR" = "nvim";
    };
  };

  boot = {
    # GRUB 2
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "/dev/sda";

    # Silent (-er) boot
    plymouth.enable = true;
  };

  # Networking
  networking = {
    hostName = "zubat";
    networkmanager = {
      enable = true;
      packages = with pkgs; [
        networkmanagerapplet
      ];
    };
  };

  # Locale
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Fonts
  fonts = {
    fonts = with pkgs; [
      font-awesome-ttf
      nerdfonts
      powerline-fonts
      ubuntu_font_family
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = ["Ubuntu"];
      };
    };
  };

  # Set your time zone and location
  time.timeZone = "Europe/Amsterdam";
  location.latitude = 52.0;
  location.longitude = 5.0;

  # Programs
  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    light.enable = true;

    # Android development
    adb.enable = true;

    # Screen lock
    xss-lock.enable = true;
    xss-lock.lockerCommand = "i3lock -c 2f302f";
  };

  # Services
  services = {
    xserver = {
      enable = true;
      layout = "gb";
      xkbOptions = "ctrl:nocaps";

      # Enable touchpad support
      libinput = {
        enable = true;
        naturalScrolling = false;
      };

      # lightdm - Cross desktop display manager
      displayManager.lightdm = {
        enable = true;
      };

      # i3 - Tiling window manager
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [ 
          dmenu
          i3status
          i3lock
        ];
      };
    };

    # Compton - X11 compositor
    compton = {
      backend = "glx";
      enable = true;
      fade = true;
      fadeDelta = 3;
      vSync = true;
    };
    
    # Redshift - Time based screen color temperature
    redshift = {
      enable = true;
      temperature = {
        day = 6000;
        night = 3500;
      };
    };

    # tlp - Laptop power saving
    tlp.enable = true;

    # Gnome Keyring - Protonmail required dependency
    gnome3.gnome-keyring.enable = true;

  };

  # VirtualBox - PC emulator
  virtualisation.virtualbox.host.enable = true;

  # Users
  users.extraUsers = {
    jhaasdijk = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "adbusers"       # Android development
        "networkmanager" # Network privileges
        "video"          # /release-notes.html#sec-release-19.03-incompatibilities
        "wheel"          # Additional system privileges
      ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
