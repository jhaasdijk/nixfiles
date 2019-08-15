
# nixos https://nixos.org/channels/nixos-19.03
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

    # Include generic folder
    ./generic
  ];

  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;

    packageOverrides = pkgs: with pkgs; {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };

      neovim = neovim.override {
        configure = {
          customRC = ''
            "---------- General ----------"
            set number
            set mouse=a
            set incsearch
            set ruler
            set cursorline
            set colorcolumn=80
            set encoding=utf-8
            filetype plugin indent on
            set scrolloff=5

            set shiftwidth=4
            set tabstop=4
            set expandtab
            set showmatch

            set noshowmode

            "---------- Bindings ----------"
            nnoremap <C-up> <C-Y>
            nnoremap <C-k> <C-Y>
            nnoremap <C-down> <C-E>
            nnoremap <C-j> <C-E>
            map <C-n> <plug>NERDTreeTabsToggle<CR>
            command Pdfrun execute "silent !pandoc --filter pandoc-citeproc -o %.pdf %" | redraw!
            map <F5> :Pdfrun<CR>
            vmap <C-c> :w !xclip -i -sel c

            "---------- Theming ----------"
            colorscheme Tomorrow-Night-Bright
            set laststatus=1
            syntax on

            hi clear CursorLine
            hi CursorLine gui=underline cterm=underline

            hi VertSplit ctermfg=5 ctermbg=bg

            let g:lightline = {
              \ 'colorscheme': 'powerline',
              \ 'active': {
              \   'left': [ [ 'mode', 'paste' ],
              \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
              \ },
              \ 'component_function': {
              \   'gitbranch': 'fugitive#head'
              \ },
              \ 'separator': { 'left': '', 'right': '' },
              \ 'subseparator': { 'left': '|', 'right': '|' },
              \ }

            "---------- Latex ----------"
            let g:livepreview_previewer = 'zathura'

            "---------- GoYo ----------"
            let g:goyo_width  = "50%+20%"
            let g:goyo_height = "100%-5%"

            "---------- Programming ----------"
            au BufNewFile,BufRead *.js, *.html, *.css
              \ set tabstop=2 |
              \ set softtabstop=2 |
              \ set shiftwidth=2

            "---------- Python ----------"
            let python_highlight_all=1
            set foldmethod=indent
            set foldlevel=99
            nnoremap <space> za
            let g:SimpylFold_docstring_preview=1
            let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

            au BufNewFile,BufRead *.py
              \ set tabstop=4 |
              \ set softtabstop=4 |
              \ set shiftwidth=4 |
              \ set textwidth=79 |
              \ set expandtab |
              \ set autoindent |
              \ set fileformat=unix

            hi BadWhitespace ctermbg=darkgreen guibg=darkgreen
            au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
          '';
	  plug.plugins = with pkgs.vimPlugins; [
        auto-pairs
        base16-vim
        goyo
        lightline-vim
        nerdtree
        tabular
        vim-colorschemes
        vim-gitgutter
        vim-latex-live-preview
        vim-markdown
        vim-nerdtree-tabs
        vim-polyglot
        vim-sensible
        vim-surround
      ];
        };
     };
  };
};

  environment = {
    systemPackages = with pkgs; [
      htop neovim libsForQt5.vlc xclip pandoc powertop firefox libreoffice
      texlive.combined.scheme-full biber zathura python3 ranger exa dunst
      teamspeak_client libnotify thunderbird unzip signal-desktop flameshot
      nix-prefetch-git plymouth gitAndTools.gitFull arandr networkmanagerapplet
      android-studio jetbrains.webstorm gimp tree sxiv tmux
      jetbrains.pycharm-community nodejs-11_x poppler_utils pavucontrol
      haskellPackages.pandoc-citeproc feh

      # protonmail local bridge implementation
      unstable.protonmail-bridge

      # cli music
      python37Packages.mps-youtube
      mpv

      # ------------------------------

      p7zip
      qbittorrent
      exfat
      bat
      fd # find alternative
      ripgrep
      vscodium

      # ------------------------------

      st
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
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Locale
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  # Sound
  sound.enable = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      dejavu_fonts
      emojione
      fira-code
      font-awesome-ttf
      iosevka
      helvetica-neue-lt-std
      nerdfonts
      powerline-fonts
      ubuntu_font_family
      xorg.fontbhlucidatypewriter100dpi
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = ["Ubuntu"];
        monospace = ["Fira Code"];
      };
      ultimate.enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Collect nix store garbage and optimise daily.
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";
  nix.optimise.automatic = true;

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
    xss-lock.lockerCommand = "i3lock -c 000000";
  };

  # Services
  services = {
    xserver = {
      enable = true;
      layout = "gb";

      # Enable touchpad support.
      libinput = {
        enable = true;
        naturalScrolling = false;
      };

      displayManager.lightdm = {
        enable = true;
        background = builtins.fetchurl {
          url = "https://hdqwalls.com/download/abstract-star-nights-time-lapse-45-2560x1600.jpg";
          sha256 = "0v5m7b5c9fdxmckqp7569yj4ga2n7xs5mi700ild89blzwsw6hr2";
        };
      };

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

    compton = {
      enable = true;
      activeOpacity = "1.0";
      inactiveOpacity = "0.85";
      # Enable when flicker appears in maximized windows
      extraOptions = ''
        unredir-if-possible = false;
        focus-exclude = "x = 0 && y = 0 && override_redirect = true";
      '';
      opacityRules = [
        "60:class_g = 'st'"
      ];
      vSync = "opengl-swc";
    };
    
    redshift = {
      enable = true;
      latitude = "52";
      longitude = "5";
      temperature = {
        day = 6000;
        night = 3500;
      };
    };

    # battery management
    tlp.enable = true;

    # Protonmail
    gnome3.gnome-keyring.enable = true;
  };

  virtualisation.virtualbox.host.enable = true;

  # Users
  users.extraUsers = {
    jhaasdijk = {
      isNormalUser = true;
      uid = 1000;
      shell = pkgs.fish;
      extraGroups = [
        "wheel" "networkmanager"
        "nm-openvpn"
        "tty" "dialout" # For arduino
        "davfs2"
        "docker"
        "wireshark"
        "fuse" # for sshfs
        "audio"
        "adbusers" # Android development
        "video" # For light
      ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
