{ config, pkgs, lib, ... }:

##### Variable definitions #####
let

  burekVariable = "burek";

in {

  imports = [ ./hardware-configuration.nix <home-manager/nixos> ];

  ##### Environment Variables #####
  environment = {
    variables = {
      # PROXY SETTINGS
      #   http_proxy = "http://proxy.site";
      #   https_proxy = "https://proxy.site";
      EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
      CUDA_PATH = "${pkgs.cudatoolkit}";
      QT_STYLE_OVERRIDE = "kvantum";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      EXTRA_CCFLAGS = "-I/usr/include";
    };

    sessionVariables = {
      LD_LIBRARY_PATH = with pkgs;
        "${stdenv.cc.cc.lib.outPath}/lib:${linuxPackages.nvidia_x11}/lib:${stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.libGL}/lib:${pkgs.libGLU}/lib:${pkgs.glibc}/lib:${pkgs.glib.out}/lib";
    };

  };

  ##### General system settings #####
  time.timeZone = "Europe/Ljubljana";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.11";
  system.autoUpgrade.enable = false;
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

  # Enable UDisks2 service for automounting
  services.udisks2.enable = true;

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

  services.xserver = { enable = true; };

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

  ##### System packages #####
  environment.systemPackages = with pkgs; [
    linuxPackages.nvidia_x11
    cudatoolkit
    alacritty
    wayland
    xdg-utils
    glib
    vim
    tmux
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
    fzf
    fd
    python3
    ruby
    rbenv
    go
    jdk
    pulumi
    bluez
    git
    wireguard-tools
    polkit_gnome
    openvpn
    zlib
    glib
    glibc
    file
    ffmpeg
    wirelesstools
    udisks2
  ];

  ##### Extra #####
  programs.zsh.enable = true;
  qt.platformTheme = "qt5ct";

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
  };
}
