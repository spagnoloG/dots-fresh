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
    networkmanagerapplet
    # Rofi plugins
    rofi-bluetooth
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
  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages =
    [ "electron-12.2.3" "electron-19.1.9" ]; # Temporal
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

      floating = {
        modifier = "Mod4";
        border = 0;
      };

      window = { border = 0; };

      # Output configuration
      #output = "* bg /home/spagnologasper/Documents/dots-fresh/wallpapers/.wallpapers/pinky.png fill";

      # Keybindings and other configurations
      keybindings = {
        "${config.wayland.windowManager.sway.config.modifier}+Return" =
          "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+q" = "kill";
        "${config.wayland.windowManager.sway.config.modifier}+d" =
          "exec --no-startup-id rofi -show drun";
        "${config.wayland.windowManager.sway.config.modifier}+n" =
          "exec --no-startup-id ~/.config/i3/rofi/bin/network_menu";
        "${config.wayland.windowManager.sway.config.modifier}+x" =
          "exec --no-startup-id ~/.config/i3/rofi/bin/powermenu";
        "${config.wayland.windowManager.sway.config.modifier}+m" =
          "exec --no-startup-id rofi-bluetooth";
        "${config.wayland.windowManager.sway.config.modifier}+F2" =
          "exec --no-startup-id ~/.config/i3/rofi/bin/windows";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+c" =
          "reload";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+e" =
          "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+space" =
          "floating toggle";
        "${config.wayland.windowManager.sway.config.modifier}+f" = "fullscreen";
        "${config.wayland.windowManager.sway.config.modifier}+b" = "splith";
        "${config.wayland.windowManager.sway.config.modifier}+v" = "splitv";
        "${config.wayland.windowManager.sway.config.modifier}+s" =
          "layout stacking";
        "${config.wayland.windowManager.sway.config.modifier}+w" =
          "layout tabbed";
        "${config.wayland.windowManager.sway.config.modifier}+e" =
          "layout toggle split";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+minus" =
          "move scratchpad";
        "${config.wayland.windowManager.sway.config.modifier}+minus" =
          "scratchpad show";
        "${config.wayland.windowManager.sway.config.modifier}+r" =
          "mode 'resize'";
        "XF86MonBrightnessUp" = "exec brightnessctl s +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl s 5%-";
        "XF86AudioRaiseVolume" =
          "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" =
          "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 0";
        "XF86AudioMicMute" =
          "exec --no-startup-id wpctl set-source-mute @DEFAULT_SOURCE@ toggle";
        "Print" = "exec flameshot gui";
        "${config.wayland.windowManager.sway.config.modifier}+F1" =
          "exec swaylock -c 000000";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+b" =
          "exec brave --enable-features=UseOzonePlatform --ozone-platform=wayland";

        # Movement
        "${config.wayland.windowManager.sway.config.modifier}+h" = "focus left";
        "${config.wayland.windowManager.sway.config.modifier}+j" = "focus down";
        "${config.wayland.windowManager.sway.config.modifier}+k" = "focus up";
        "${config.wayland.windowManager.sway.config.modifier}+l" =
          "focus right";
        "${config.wayland.windowManager.sway.config.modifier}+Left" =
          "focus left";
        "${config.wayland.windowManager.sway.config.modifier}+Down" =
          "focus down";
        "${config.wayland.windowManager.sway.config.modifier}+Up" = "focus up";
        "${config.wayland.windowManager.sway.config.modifier}+Right" =
          "focus right";

        # Workspace management
        "${config.wayland.windowManager.sway.config.modifier}+1" =
          "workspace number 1";
        "${config.wayland.windowManager.sway.config.modifier}+2" =
          "workspace number 2";
        "${config.wayland.windowManager.sway.config.modifier}+3" =
          "workspace number 3";
        "${config.wayland.windowManager.sway.config.modifier}+4" =
          "workspace number 4";
        "${config.wayland.windowManager.sway.config.modifier}+5" =
          "workspace number 5";
        "${config.wayland.windowManager.sway.config.modifier}+6" =
          "workspace number 6";
        "${config.wayland.windowManager.sway.config.modifier}+7" =
          "workspace number 7";
        "${config.wayland.windowManager.sway.config.modifier}+8" =
          "workspace number 8";
        "${config.wayland.windowManager.sway.config.modifier}+9" =
          "workspace number 9";
        "${config.wayland.windowManager.sway.config.modifier}+0" =
          "workspace number 0";

        # Moving containers to workspaces
        "${config.wayland.windowManager.sway.config.modifier}+Shift+1" =
          "move container to workspace number 1";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+2" =
          "move container to workspace number 2";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+3" =
          "move container to workspace number 3";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+4" =
          "move container to workspace number 4";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+5" =
          "move container to workspace number 5";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+6" =
          "move container to workspace number 6";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+7" =
          "move container to workspace number 7";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+8" =
          "move container to workspace number 8";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+9" =
          "move container to workspace number 9";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+0" =
          "move container to workspace number 0";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+Right" =
          "move container to output right";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+Left" =
          "move container to output left";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+Up" =
          "move container to output up";
        "${config.wayland.windowManager.sway.config.modifier}+Shift+Down" =
          "move container to output down";
      };

    };

    extraConfig = ''
      for_window [class="^.*"] border pixel 1
      for_window [class="feh"] floating enable, border none resize set 1600 1000, move position center
      output * bg /home/spagnologasper/Documents/dots-fresh/wallpapers/.wallpapers/pinky.png fill
      exec_always --no-startup-id nm-applet
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

  services.kanshi = {
    enable = true;

    profiles = {
      profile1 = {
        outputs = [
          {
            criteria = "Dell Inc. DELL P2419HC H565L03";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };

      profile2 = {
        outputs = [{
          criteria = "California Institute of Technology 0x1410 Unknown";
          mode = "3072x1920@120Hz";
          scale = 1.0;
        }];
      };

      lj_setup = {
        outputs = [
          {
            criteria = "Samsung Electric Company C34H89x H4ZRB05512";
            mode = "3440x1440@100Hz";
          }
          {
            criteria = "California Institute of Technology 0x1410 Unknown";
            status = "disable";
          }
        ];
      };

      portable_monitor = {
        outputs = [
          {
            criteria = "California Institute of Technology 0x1410 Unknown";
            mode = "3072x1920@120Hz";
            scale = 1.0;
            position = "1128,3130";
          }
          {
            criteria = "Avolites Ltd ARZOPA -S1 0000000000000";
            mode = "1920x1080@60Hz";
            position = "1690,2050";
          }
        ];
      };

      portable_monitor_2 = {
        outputs = [
          {
            criteria = "AU Optronics 0x313D Unknown";
            mode = "1920x1080@60Hz";
            scale = 1.0;
            position = "1920,1080";
          }
          {
            criteria = "Avolites Ltd ARZOPA -S1 0000000000000";
            mode = "1920x1080@60Hz";
            position = "1920,0";
          }
        ];
      };

      lj_setup_2 = {
        outputs = [
          {
            criteria = "AU Optronics 0x313D Unknown";
            status = "disable";
          }
          {
            criteria = "Samsung Electric Company C34H89x H4ZRB05512";
            mode = "3440x1440@60Hz";
          }
        ];
      };

      profile7 = {
        outputs = [{
          criteria = "AU Optronics 0x313D Unknown";
          mode = "1920x1080@60Hz";
          scale = 1.0;
        }];
      };
    };
  };

  services.mako = {
    enable = true;
    defaultTimeout = 10000;
    font = "Iosevka 14";
    backgroundColor = "#191818";
    textColor = "#d2d2d2";
    borderColor = "#474343";
    borderRadius = 6;
    height = 700;
    width = 400;
    format = ''
      <b>%s</b>
      %b'';
  };

  gtk = {
    gtk2 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
        "gtk-button-images" = true;
        "gtk-cursor-theme-name" = "breeze_cursors";
        "gtk-cursor-theme-size" = 24;
        "gtk-decoration-layout" = "icon:minimize,maximize,close";
        "gtk-enable-animations" = true;
        "gtk-font-name" = "Noto Sans, 10";
        "gtk-icon-theme-name" = "breeze-dark";
        "gtk-menu-images" = true;
        "gtk-modules" = "colorreload-gtk-module";
        "gtk-primary-button-warps-slider" = false;
        "gtk-theme-name" = "Matcha-dark-azul";
        "gtk-toolbar-style" = 3;
        "gtk-xft-dpi" = 147456;
      };
    };
    gtk3 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
        "gtk-button-images" = true;
        "gtk-cursor-theme-name" = "breeze_cursors";
        "gtk-cursor-theme-size" = 24;
        "gtk-decoration-layout" = "icon:minimize,maximize,close";
        "gtk-enable-animations" = true;
        "gtk-font-name" = "Noto Sans, 10";
        "gtk-icon-theme-name" = "breeze-dark";
        "gtk-menu-images" = true;
        "gtk-modules" = "colorreload-gtk-module";
        "gtk-primary-button-warps-slider" = false;
        "gtk-theme-name" = "Matcha-dark-azul";
        "gtk-toolbar-style" = 3;
        "gtk-xft-dpi" = 147456;
      };
    };
    gtk4 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
        "gtk-button-images" = true;
        "gtk-cursor-theme-name" = "breeze_cursors";
        "gtk-cursor-theme-size" = 24;
        "gtk-decoration-layout" = "icon:minimize,maximize,close";
        "gtk-enable-animations" = true;
        "gtk-font-name" = "Noto Sans, 10";
        "gtk-icon-theme-name" = "breeze-dark";
        "gtk-menu-images" = true;
        "gtk-modules" = "colorreload-gtk-module";
        "gtk-primary-button-warps-slider" = false;
        "gtk-theme-name" = "Matcha-dark-azul";
        "gtk-toolbar-style" = 3;
        "gtk-xft-dpi" = 147456;
      };
    };
  };

  programs.rofi = {
    enable = true;
    location = "center";
    terminal = "alacritty";

    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      " @import" = "catppuccin-mocha";
      # Additional theme configurations go here.
    };

    extraConfig = {
      modi = "run,drun,window";
      disable-history = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-network = " 󰤨  Network";
      drun-display-format = "{icon} {name}";
      hide-scrollbar = true;
      icon-theme = "Oranchelo";
      show-icons = true;
      sidebar-mode = true;
      # Additional configurations go here.
    };
  };

  programs.zathura = {
    enable = true;

    options = {
      font = "Iosevka 16px";

      inputbar-fg = "#161616";
      inputbar-bg = "#909737";

      statusbar-fg = "#161616";
      statusbar-bg = "#909737";

      completion-fg = "#161616";
      completion-bg = "#909737";

      completion-highlight-fg = "#909737";
      completion-highlight-bg = "#161616";

      recolor-lightcolor = "#161616";
      recolor-darkcolor = "#ffffff";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withRuby = false;
    withPython3 = false;
    defaultEditor = true;
    coc.enable = false;

    extraPackages = with pkgs; [
      # for compiling Treesitter parsers
      gcc

      # debuggers
      lldb # comes with lldb-vscode

      # formatters and linters
      nixfmt
      rustfmt
      shfmt
      stylua
      codespell
      statix
      luajitPackages.luacheck
      prettierd

      # LSP servers
      nil
      rust-analyzer
      taplo
      gopls
      lua
      shellcheck
      marksman
      sumneko-lua-language-server
      yaml-language-server

      # this includes css-lsp, html-lsp, json-lsp, eslint-lsp
      nodePackages_latest.vscode-langservers-extracted

      # other utils and plugin dependencies
      src-cli
      ripgrep
      fd
      catimg
      sqlite
      lemmy-help
      luajitPackages.jsregexp
      fzf
      cargo
      clippy
      glow
    ];
  };

  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 1.0;
        padding = {
          x = 5;
          y = 5;
        };
      };

      font = {
        normal = {
          family = "Iosevka";
          style = "Regular";
        };
        size = 12;
      };

      liveConfigReload = true;
      dynamicPadding = true;

      colors = {
        primary = {
          background = "#24273A";
          foreground = "#CAD3F5";
          dim_foreground = "#CAD3F5";
          bright_foreground = "#CAD3F5";
        };

        cursor = {
          text = "#24273A";
          cursor = "#F4DBD6";
        };

        vi_mode_cursor = {
          text = "#24273A";
          cursor = "#B7BDF8";
        };

        search = {
          matches = {
            foreground = "#24273A";
            background = "#A5ADCB";
          };
          focused_match = {
            foreground = "#24273A";
            background = "#A6DA95";
          };
          footer_bar = {
            foreground = "#24273A";
            background = "#A5ADCB";
          };
        };

        hints = {
          start = {
            foreground = "#24273A";
            background = "#EED49F";
          };
          end = {
            foreground = "#24273A";
            background = "#A5ADCB";
          };
        };

        selection = {
          text = "#24273A";
          background = "#F4DBD6";
        };

        normal = {
          black = "#494D64";
          red = "#ED8796";
          green = "#A6DA95";
          yellow = "#EED49F";
          blue = "#8AADF4";
          magenta = "#F5BDE6";
          cyan = "#8BD5CA";
          white = "#B8C0E0";
        };

        bright = {
          black = "#5B6078";
          red = "#ED8796";
          green = "#A6DA95";
          yellow = "#EED49F";
          blue = "#8AADF4";
          magenta = "#F5BDE6";
          cyan = "#8BD5CA";
          white = "#A5ADCB";
        };

        dim = {
          black = "#494D64";
          red = "#ED8796";
          green = "#A6DA95";
          yellow = "#EED49F";
          blue = "#8AADF4";
          magenta = "#F5BDE6";
          cyan = "#8BD5CA";
          white = "#B8C0E0";
        };

        indexed_colors = [
          {
            index = 16;
            color = "#F5A97F";
          }
          {
            index = 17;
            color = "#F4DBD6";
          }
        ];
      };
    };
  };
}
