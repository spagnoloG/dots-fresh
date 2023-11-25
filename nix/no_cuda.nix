{ config, pkgs, lib, ... }:

##### Variable definitions #####
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

  neovimOverlay = self: super: {
    neovim = super.neovim.override {
      viAlias = true;
      vimAlias = true;
    };
  };

  my-R-packages = with pkgs.rPackages; [
    ggplot2
    dplyr
    xts
    gridExtra
    shiny
    shinydashboard
    tidyr
    tidyverse
    viridis
  ];

  RStudio-with-my-packages =
    pkgs.rstudioWrapper.override { packages = my-R-packages; };

  R-with-my-packages = pkgs.rWrapper.override { packages = my-R-packages; };

  python-with-my-packages = pkgs.python3.withPackages (pkgs: with pkgs; [ pyqt5  pyxdg ]);

in {

  imports = [ ./hardware-configuration.nix <home-manager/nixos> ];

  ##### Environment Variables #####
  environment = {
    variables = {
      # Since setting LD_LIBRARY_PATH system-wide can interfere with other applications, 
      # I've commented it out, but you can uncomment if you find it necessary.
      # LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib";
      QT_STYLE_OVERRIDE = "kvantum";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      EXTRA_CCFLAGS = "-I/usr/include";
    };

    sessionVariables = {
      LD_LIBRARY_PATH = with pkgs;
        "${stdenv.cc.cc.lib.outPath}/lib:${stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.libGL}/lib:${pkgs.libGLU}/lib:${pkgs.glibc}/lib:${pkgs.glib.out}/lib";
    };
  };

  ##### General system settings #####
  time.timeZone = "Europe/Ljubljana";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.05";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  nixpkgs.config.allowUnfree = true;

  ##### Hardware and bootloader configurations #####
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-intel" "wireguard" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Bluetooth
  hardware.bluetooth.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ libGLU libGL ];
  };

  services.qemuGuest.enable = true;
  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    qemu = {
      ovmf.enable = true;
      runAsRoot = true;
    };
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  ##### Networking settings #####
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.extraHosts = ''
    78.46.195.184    grafana.ataka.local    adminer.ataka.local    api.ataka.local    rabbitmq.ataka.local
    192.168.88.127	nextcloud.hsrv 
    192.168.88.59 	jellyfin.hsrv 
    192.168.88.54 	photoprism.hsrv 
    192.168.88.31 	transmission.hsrv 
  '';

  ##### Services ####
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "sway";
      sddm = { enable = true; };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.dbus.enable = true;
  services.printing.enable = true;

  # start polkit on login
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  security.polkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  ##### Fonts #####
  fonts.fonts = with pkgs; [
    fira-code
    fira
    cooper-hewitt
    ibm-plex
    jetbrains-mono
    iosevka
    spleen
    fira-code-symbols
    powerline-fonts
    nerdfonts
  ];

  ##### System packages #####
  environment.systemPackages = with pkgs; [
    alacritty
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils
    glib
    vim
    remmina
    unclutter
    nitrogen
    tmux
    pcmanfm
    vlc
    docker-compose
    virt-manager
    libguestfs
    libvirt
    coreutils
    binutils
    pciutils
    dmidecode
    autoconf
    gcc
    gnumake
    llvm
    libclang
    clang
    cmake
    libtool
    libvterm
    ncurses5
    stdenv.cc
    wget
    curl
    curl.dev
    git-lfs
    man
    mkpasswd
    unzip
    direnv
    lshw
    zsh
    oh-my-zsh
    bat
    fzf
    fd
    python-with-my-packages
    ruby
    rbenv
    go
    jdk
    kubectl
    minikube
    helm
    awscli
    terraform
    ansible
    kops
    pulumi
    brave
    bluez
    blueberry
    git
    stow
    brightnessctl
    flameshot
    feh
    neofetch
    cava
    nvtop
    acpi
    wireguard-tools
    htop
    nodejs_18
    ranger
    nmap
    uget
    p7zip
    zip
    unzip
    jq
    polkit_gnome
    openvpn
    tshark
    tcpdump
    zlib
    glib
    sshpass
    anki-bin
    catppuccin-kvantum
    glibc
    file
    btop
    joplin-desktop
    pavucontrol
    rsbkb
    google-chrome
    ffmpeg
    parallel
    ripgrep
    nload
  ];

  ##### Extra #####
  # Wayland options for brave
  programs.zsh.enable = true;
  qt.platformTheme = "qt5ct";
  nixpkgs.config.permittedInsecurePackages =
    [ "electron-12.2.3" ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  ##### User configurations ######
  users.users.spagnologasper = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "spagnologasper";
    extraGroups = [
      "wheel"
      "disk"
      "libvirtd"
      "docker"
      "audio"
      "video"
      "input"
      "systemd-journal"
      "networkmanager"
      "network"
    ];
    packages = with pkgs; [ firefox ];
  };

  ##### Home manager ######
  home-manager.users.spagnologasper = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [ "electron-12.2.3" ]; # Temporal
    nixpkgs.config.brave.commandLineArgs =
    	"--enable-features=UseOzonePlatform --ozone-platform=wayland";

    nixpkgs.overlays = [ neovimOverlay ];
    home.packages = with pkgs; [
      # Cursed R
      RStudio-with-my-packages
      R-with-my-packages
      R
      # Appearence
      dracula-theme
      gnome3.adwaita-icon-theme
      # Development
      neovim
      dbeaver
      postman
      libreoffice
      zathura
      conda
      vscode
      # Tools
      gparted
      etcher
      filezilla
      xournalpp
      pdftk
      pandoc
      texlive.combined.scheme-full
      # Audio video image
      easyeffects
      krita
      spotify
      shotwell
      fdupes # find image duplicates based on their contents
      mpv
      gimp
      imagemagick
      # Voice chat
      discord
      zoom-us
      # Shell extras
      starship
      lsd
      # Learning
      anki-bin
      # Games
      superTuxKart
      # Security
      steghide
      exiftool
      fcrackzip
      ghidra-bin
      # Format tools
      black
      nixfmt
      # OBSS
      octaveFull
    ];
    programs.waybar.enable = true;

    home.stateVersion = "23.05";

    programs.vscode = {
    	enable = true;
    	extensions = with pkgs.vscode-extensions; [
    	  dracula-theme.theme-dracula
    	  vscodevim.vim
    	  yzhang.markdown-all-in-one
            github.copilot
    	];
    };

    programs.git = {
      enable = true;
      userName = "Gašper Spagnolo";
      userEmail = "gasper.spagnolo@outlook.com";
      signing.key = "9EE5C796920C339839F4EFF646DCDBC936F8414C";
      signing.signByDefault = true;

      aliases = {
        ci = "commit";
        co = "checkout";
        cp = "cherry-pick";
        s = "status -uall";
        br = "branch";
        aliases = "!git config -l | grep alias | cut -c 7-";
        hist =
          "log --pretty=format:'%C(yellow)%h%Creset%C(auto)%d - %s %Cblue[%an]' --graph --date=short --decorate --branches --remotes --tags";
        blobs =
          "!git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 | cut -c 1-12,41- | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest";
        fap = "fetch --all --prune --progress";
      };
    };

    programs.zsh = {
      enable = true;
      shellAliases = {
        md-notes = "cd ~/Documents/md-notes/ && nvim .";
        randwall = "feh --bg-scale --randomize ~/pictures/wallpapers/*";
        zapiski = "~/Documents/faks_git/FRI-ZAPISKI";
        ctf = "cd ~/Documents/ctf/2022";
        faks = "cd ~/Documents/faks";
        faks-git = "cd ~/Documents/faks_git";
        rm = "rm -i";
        night = "brightnessctl s 1%";
        nightlock = "swaylock -c 000000";
        hsrv = "ssh hsrv";
        rs = "export QT_QPA_PLATFORM=xcb; rstudio-bin --no-sandbox &";
        rot13 = "tr 'A-Za-z' 'N-ZA-Mn-za-m'";
        nix-update = "nix-channel --update && nix-env -u";
        ls = "lsd";
        sus = "systemctl suspend";
        sur = "systemctl reboot";
        sup = "power off";
        hg = "history | grep";
      };
      initExtra = ''
            export EDITOR='nvim'

        	bin_txt() {
                curl -X PUT --data "$1" https://p.spanskiduh.dev
            }

            bin_file() {
                curl -X PUT --data-binary "@$1" https://p.spanskiduh.dev
            }

            # Initialize starship
            eval "$(starship init zsh)"

	    # Gpg tty
	    GPG_TTY=$(tty)
	    export GPG_TTY
      '';
      oh-my-zsh = {
        enable = true;
        theme = "cypher";
        plugins = [
          "sudo"
          "terraform"
          "systemadmin"
          "vi-mode"
          "z"
          "colorize"
          "compleat"
          "ansible"
        ];
      };

      plugins = [{
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }];
    };

    programs.tmux = {
      enable = true;
      clock24 = true;

      extraConfig = ''
        # Alacritty term support
        set -g default-terminal "tmux-256color"
        set -sg terminal-overrides ",*:RGB"

        # Enable vim keys
        set-window-option -g mode-keys vi
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind -r ^ last-window

        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'

        # Remap prefix to Control + a
        # unbind C-b
        # set-option -g prefix C-a
        # bind-key C-a send-prefix

        # Set mouse
        set -g mouse on

        # Increase history size
        set-option -g history-limit 10000

        bind-key E run-shell "script -f /tmp/script_log.txt"

        # Scripts
        # bind-key -r S run-shell "tmux neww ~/.local/scripts/ssh-connect.sh"
        # bind-key T run-shell "tmux neww tms"

        # Colors
        set-option -g pane-active-border-style fg='#6272a4'
        set-option -g pane-border-style fg='#ff79c6'
        # set-option -g status-bg black
        set-option -g status-fg black
	set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
    	run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      '';
    };

  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      mako
      kanshi
      alacritty
      dmenu
      grim
      slurp
      bemenu
      wdisplays
      rofi
      wl-mirror
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      aws.style = "bold #ffb86c";
      cmd_duration.style = "bold #f1fa8c";
      directory.style = "bold #50fa7b";
      hostname.style = "bold #ff5555";
      git_branch.style = "bold #ff79c6";
      git_status.style = "bold #ff5555";
      username = {
        format = "[$user]($style) on ";
        style_user = "bold #bd93f9";
      };
      character = {
        success_symbol = "[λ](bold #f8f8f2)";
        error_symbol = "[λ](bold #ff5555)";
      };
    };
  };
}

