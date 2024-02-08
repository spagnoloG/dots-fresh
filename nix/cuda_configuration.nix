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

in {

  imports = [ ./hardware-configuration.nix <home-manager/nixos> ];

  ##### Environment Variables #####
  environment = {
    variables = {
      # Since setting LD_LIBRARY_PATH system-wide can interfere with other applications, 
      # I've commented it out, but you can uncomment if you find it necessary.
      # LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib";
      EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
      CUDA_PATH = "${pkgs.cudatoolkit}";
      QT_STYLE_OVERRIDE = "kvantum";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      EXTRA_CCFLAGS = "-I/usr/include";
    };

  };

  ##### General system settings #####
  time.timeZone = "Europe/Ljubljana";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.11";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  nixpkgs.config.allowUnfree = true;

  ##### Hardware and bootloader configurations #####
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-intel" "wireguard" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];

  ### CUDA  ###
  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  virtualisation.docker.enableNvidia = true; # Enable GPU support in container

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

  # Bluetooth
  hardware.bluetooth.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ libGLU libGL ];
  };

  ### KVM ###
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

  networking.extraHosts = "";

  ##### Services ####
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #  extraSessionCommands = ''
  #    export SDL_VIDEODRIVER=wayland
  #    export QT_QPA_PLATFORM=wayland
  #    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  #    export _JAVA_AWT_WM_NONREPARENTING=1
  #    export MOZ_ENABLE_WAYLAND=1
  #  '';
  #  extraOptions = [ "--unsupported-gpu" ];
  #};

  services.xserver = {
    enable = true;
    displayManager = {
      #defaultSession = "sway";
      lightdm = {
        enable = true;
        greeters.enso = {
          enable = true;
          theme.name = "Numix";
          theme.package = pkgs.numix-gtk-theme;
        };
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
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
  fonts.packages = with pkgs; [
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

  environment = {
    # Setup global proxy
    #variables = {
    #   http_proxy = "http://proxy.site";
    #   https_proxy = "https://proxy.site";
    #};
    sessionVariables = {
      LD_LIBRARY_PATH = with pkgs;
        "${stdenv.cc.cc.lib.outPath}/lib:${linuxPackages.nvidia_x11}/lib:${stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.libGL}/lib:${pkgs.libGLU}/lib:${pkgs.glibc}/lib:${pkgs.glib.out}/lib";
    };

  };

  ##### System packages #####
  environment.systemPackages = with pkgs; [
    linuxPackages.nvidia_x11
    cudatoolkit
    #sway
    alacritty
    #dbus-sway-environment
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
    python3
    ruby
    rbenv
    go
    jdk
    ansible
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
    wirelesstools
  ];

  ##### Extra #####
  # Wayland options for brave
  programs.zsh.enable = true;
  qt.platformTheme = "qt5ct";
  nixpkgs.config.permittedInsecurePackages = [ "electron-12.2.3" ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Steam cannot be installed using home-manager, so let it be global for now
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
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
}
