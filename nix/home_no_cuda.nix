{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "spagnologasper";
  home.homeDirectory = "/home/spagnologasper";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    sway
    R
    # Appearence
    dracula-theme
    gnome3.adwaita-icon-theme
    # Development
    neovim
    dbeaver
    #postman
    libreoffice
    zathura
    okular
    conda
    vscode
    # Tools
    gparted
    etcher
    filezilla
    xournalpp
    pdftk
    pandoc
    #texlive.combined.scheme-full
    # Database connection tools
    mysql
    #mongodb .. install it using nix-shell as it build itself each time (time consuming)
    sqlite
    postgresql
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
    # Sway
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
    # Audo control
    pulsemixer
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/spagnologasper/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-12.2.3" "electron-19.1.9" ]; # Temporal
  nixpkgs.config.brave.commandLineArgs =
  "--enable-features=UseOzonePlatform --ozone-platform=wayland";


  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 46.0569;
    longitude = 14.5058;
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
      github.copilot
    ];
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

  wayland.windowManager.sway = {
    enable = true;

    config = {
      # Set variables
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";

      # Client styling
      colors = {
        focused = {
          border = "#DA6E89";
          background = "#DA6E89";
          text = "#FFFFFF";
          indicator = "#98C379";
          childBorder = "#DA6E89";
        };
        focusedInactive = {
          border = "#61AFEF";
          background = "#61AFEF";
          text = "#1E222A";
          indicator = "#98C379";
          childBorder = "#61AFEF";
        };
        unfocused = {
          border = "#2C3038";
          background = "#2C3038";
          text = "#FFFFFF";
          indicator = "#98C379";
          childBorder = "#2C3038";
        };
        urgent = {
          border = "#C678DD";
          background = "#C678DD";
          text = "#FFFFFF";
          indicator = "#98C379";
          childBorder = "#C678DD";
        };
        placeholder = {
          border = "#1E222A";
          background = "#1E222A";
          text = "#FFFFFF";
          indicator = "#98C379";
          childBorder = "#1E222A";
        };
        background = "#1E222A";
      };

      floating ={
          modifier = "Mod4";
          border = 0;
      };

      window = {
          border = 0;
      };

      # Output configuration
      #output = "* bg /home/spagnologasper/Documents/dots-fresh/wallpapers/.wallpapers/pinky.png fill";

      # Keybindings and other configurations
       keybindings = {
        "${config.wayland.windowManager.sway.config.modifier}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+q" = "kill";
        "${config.wayland.windowManager.sway.config.modifier}+d" = "exec --no-startup-id rofi -show drun";
        "${config.wayland.windowManager.sway.config.modifier}+n" = "exec --no-startup-id ~/.config/i3/rofi/bin/network_menu";
        "${config.wayland.windowManager.sway.config.modifier}+x" = "exec --no-startup-id ~/.config/i3/rofi/bin/powermenu";
        "${config.wayland.windowManager.sway.config.modifier}+m" = "exec --no-startup-id ~/.config/i3/rofi/bin/mpd";
        "${config.wayland.windowManager.sway.config.modifier}+F2" = "exec --no-startup-id ~/.config/i3/rofi/bin/windows";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+c" = "reload";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+space" = "floating toggle";
        "${config.wayland.windowManager.sway.config.modifier}+f" = "fullscreen";
        "${config.wayland.windowManager.sway.config.modifier}+b" = "splith";
        "${config.wayland.windowManager.sway.config.modifier}+v" = "splitv";
        "${config.wayland.windowManager.sway.config.modifier}+s" = "layout stacking";
        "${config.wayland.windowManager.sway.config.modifier}+w" = "layout tabbed";
        "${config.wayland.windowManager.sway.config.modifier}+e" = "layout toggle split";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+minus" = "move scratchpad";
        "${config.wayland.windowManager.sway.config.modifier}+minus" = "scratchpad show";
        "${config.wayland.windowManager.sway.config.modifier}+r" = "mode 'resize'";
        "XF86MonBrightnessUp" = "exec brightnessctl s +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl s 5%-";
        "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 0";
        "XF86AudioMicMute" = "exec --no-startup-id wpctl set-source-mute @DEFAULT_SOURCE@ toggle";
        "Print" = "exec flameshot gui";
        "${config.wayland.windowManager.sway.config.modifier}+F1" = "exec swaylock -c 000000";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+b" = "exec brave --enable-features=UseOzonePlatform --ozone-platform=wayland";

        # Movement
        "${config.wayland.windowManager.sway.config.modifier}+h" = "focus left";
        "${config.wayland.windowManager.sway.config.modifier}+j" = "focus down";
        "${config.wayland.windowManager.sway.config.modifier}+k" = "focus up";
        "${config.wayland.windowManager.sway.config.modifier}+l" = "focus right";
        "${config.wayland.windowManager.sway.config.modifier}+Left" = "focus left";
        "${config.wayland.windowManager.sway.config.modifier}+Down" = "focus down";
        "${config.wayland.windowManager.sway.config.modifier}+Up" = "focus up";
        "${config.wayland.windowManager.sway.config.modifier}+Right" = "focus right";

        # Workspace management
        "${config.wayland.windowManager.sway.config.modifier}+1" = "workspace number 1";
        "${config.wayland.windowManager.sway.config.modifier}+2" = "workspace number 2";
        "${config.wayland.windowManager.sway.config.modifier}+3" = "workspace number 3";
        "${config.wayland.windowManager.sway.config.modifier}+4" = "workspace number 4";
        "${config.wayland.windowManager.sway.config.modifier}+5" = "workspace number 5";
        "${config.wayland.windowManager.sway.config.modifier}+6" = "workspace number 6";
        "${config.wayland.windowManager.sway.config.modifier}+7" = "workspace number 7";
        "${config.wayland.windowManager.sway.config.modifier}+8" = "workspace number 8";
        "${config.wayland.windowManager.sway.config.modifier}+9" = "workspace number 9";
        "${config.wayland.windowManager.sway.config.modifier}+0" = "workspace number 0";

        # Moving containers to workspaces
        "${config.wayland.windowManager.sway.config.modifier}+Shift+1" = "move container to workspace number 1";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+2" = "move container to workspace number 2";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+3" = "move container to workspace number 3";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+4" = "move container to workspace number 4";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+5" = "move container to workspace number 5";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+6" = "move container to workspace number 6";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+7" = "move container to workspace number 7";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+8" = "move container to workspace number 8";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+9" = "move container to workspace number 9";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+0" = "move container to workspace number 0";

         };

    };

    extraConfig = ''
        for_window [class="^.*"] border pixel 1
        for_window [class="feh"] floating enable, border none resize set 1600 1000, move position center
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

