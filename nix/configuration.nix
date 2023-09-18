{ config, pkgs, lib, ... }:

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
  
  # This overlay allows us to override some nixpkgs attributes.
  neovimOverlay = self: super: {
    neovim = super.neovim.override {
      viAlias = true;
      vimAlias = true;
    };
  };

in {

  imports = [ ./hardware-configuration.nix ];

  # General system settings
  time.timeZone = "Europe/Ljubljana";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.05";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  nixpkgs.config.allowUnfree = true;

  # Hardware and bootloader configurations
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-intel"  "wireguard"];
  boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Networking settings
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # User configurations
  users.users.spagnologasper = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "spagnologasper";
    extraGroups = [ "wheel" "disk" "libvirtd" "docker" "audio" "video" "input" "systemd-journal" "networkmanager" "network" ];
    packages = with pkgs; [ firefox ];
  };

  # Services
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Nvidia GPU
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,	
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia"];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  nixpkgs.config.cudaSupport = true;
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

  # Fonts
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

  # Sway and related settings
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      mako
      grim
      kanshi
      slurp
      alacritty
      dmenu
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
    extraOptions = [
      "--unsupported-gpu"
    ];
  };
  programs.waybar.enable = true;
  qt.platformTheme = "qt5ct";

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "sway";
      sddm = {
        enable = true;
      };
    };
  };
	
  # Wayland options for brave
  nixpkgs.config.brave.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
	
  # Packages
  environment.systemPackages = with pkgs; [
    alacritty
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils
    glib
    dracula-theme
    gnome3.adwaita-icon-theme
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    bemenu
    mako
    wdisplays
    vim
    neovim
    jetbrains.datagrip
    jetbrains.idea-ultimate
    dbeaver
    postman
    gparted
    remmina
    unclutter
    cudatoolkit
    linuxPackages.nvidia_x11
    picom
    nitrogen
    rofi
    tmux
    pcmanfm
    filezilla
    libreoffice
    zoom-us
    vlc
    etcher
    krita
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
    libGLU
    libGL
    libtool
    libvterm
    ncurses5
    stdenv.cc
    wget
    curl
    git-lfs
    man
    mkpasswd
    unzip
    direnv
    lshw
    zsh
    oh-my-zsh
    starship
    bat
    fzf
    fd
    python3
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
    discord
    spotify
    brave
    bluez
    blueberry
    git
    stow
    brightnessctl
    flameshot
    feh
    zathura
    neofetch
    cava
    nvtop
    acpi
    wireguard-tools
    lsd
    htop
    nodejs_18
    ranger
    nmap
  ];

  nixpkgs.overlays = [ neovimOverlay ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-12.2.3" ];

  # Env variables
  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    # Since setting LD_LIBRARY_PATH system-wide can interfere with other applications, 
    # I've commented it out, but you can uncomment if you find it necessary.
    # LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
  };


  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.mtr.enable = true;
  programs.zsh = {
     enable = true;
     # Set the aliases
     shellAliases = {
  	md-notes = "cd ~/Documents/md-notes/ && nvim .";
  	randwall = "feh --bg-scale --randomize ~/pictures/wallpapers/*";
  	zapiski = "~/Documents/faks_git/FRI-ZAPISKI";
  	ctf = "cd ~/Documents/ctf/2022";
  	faks = "cd ~/Nextcloud/faks/3-letnik/2sem";
  	faks-git = "cd ~/Documents/faks_git";
  	rm = "rm -i";
  	night = "brightnessctl s 1%";
  	nightlock = "swaylock -c 000000";
  	hsrv = "ssh hsrv";
  	rs = "export QT_QPA_PLATFORM=xcb; rstudio-bin --no-sandbox &";
  	rot13 = "tr 'A-Za-z' 'N-ZA-Mn-za-m'";
  	nix-update = "nix-channel --update && nix-env -u";
	ls = "lsd";
     };
     shellInit = ''
     	export EDITOR='nvim'
     '';
     autosuggestions.enable = true;
     ohMyZsh = {
       enable = true;
       theme = "cypher";
       plugins = [
          "sudo"
          "terraform"
          "systemadmin"
          "vi-mode"
	  "z"
	  "colorize"
	  "fzf"
	  "compleat"
	  "ansible"
	  "thefuck"
      ];
    };	
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
    '';
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;

  ## Wireguard, skip for now as it does not wanna work, using network manager for now
  #networking.firewall.allowedUDPPorts = [ 51820 ]; # allow wireguard traffic through firewall

  #networking.wireguard.interfaces = {
  #  de = {
  #    ips = [ "10.13.13.3" ];
  #    listenPort = 51820;

  #    # Note: If you have a separate file for the private key, use the `privateKeyFile` option.
  #    privateKeyFile = "/etc/nixos/wireguard/de_privkey";

  #    peers = [
  #      {
  #        allowedIPs = [ "0.0.0.0/0" ];
  #        persistentKeepalive = 25;
  #      }
  #    ];
  #  };
  #};

}

