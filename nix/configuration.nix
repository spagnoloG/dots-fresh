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
  boot.kernelModules = [ "kvm-intel" ];

  # Networking settings
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # User configurations
  users.users.spagnologasper = {
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
  };
  programs.waybar.enable = true;
  qt.platformTheme = "qt5ct";
  hardware.opengl.driSupport32Bit = true;

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
    kops
    pulumi
    discord
    spotify
    brave
    bluez
    blueberry
    tmux
    git
    stow
    brightnessctl
    flameshot
  ];

  nixpkgs.overlays = [ neovimOverlay ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-12.2.3" ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;
}
