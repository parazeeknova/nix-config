{ config, pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;
  home.stateVersion = "24.05";

  # Import Program Configurations
  imports =[
    ../dotfiles/emoji.nix
    ../dotfiles/hyprland.nix
    ../dotfiles/rofi/rofi.nix
    ../dotfiles/rofi/config-emoji.nix
    ../dotfiles/rofi/config-long.nix
    ../dotfiles/swaync.nix
    ../dotfiles/waybar.nix
    ../dotfiles/wlogout.nix
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../dotfiles/wallpapers;
    recursive = true;
  };
  home.file.".config/fastfetch" = {
    source = ../../dotfiles/fastfetch;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../dotfiles/wlogout;
    recursive = true;
  };
  home.file.".face.icon".source = ../dotfiles/face.jpg;
  home.file.".config/face.jpg".source = ../dotfiles/face.jpg;

  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${userSettings.username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Styling Options
  stylix.targets.waybar.enable = true;
  stylix.targets.rofi.enable = true;
  stylix.targets.hyprland.enable = true;
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk3";
  };

  # Scripts
  home.packages = [
    (import ./scripts/emopicker9000.nix { inherit pkgs; })
    (import ./scripts/task-waybar.nix { inherit pkgs; })
    (import ./scripts/squirtle.nix { inherit pkgs; })
    (import ./scripts/nvidia-offload.nix { inherit pkgs; })
    (import ./scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ./scripts/web-search.nix { inherit pkgs; })
    (import ./scripts/rofi-launcher.nix { inherit pkgs; })
    (import ./scripts/screenshootin.nix { inherit pkgs; })
    (import ./scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];
  
  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
          starship = {
            enable = true;
            package = pkgs.starship;
          };
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        fr = "nh os switch --hostname ${systemSettings.hostname} /home/${userSettings.username}/zaneyos";
        fu = "nh os switch --hostname ${systemSettings.hostname} --update /home/${userSettings.username}/zaneyos";
        zu = "sh <(curl -L https://gitlab.com/Zaney/zaneyos/-/raw/main/install-zaneyos.sh)";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        ".." = "cd ..";
      };
    };
    home-manager.enable = true;
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "/home/${userSettings.username}/Pictures/Wallpapers/zaney-wallpaper.jpg";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        image = [
          {
            path = "/home/${userSettings.username}/.config/face.jpg";
            size = 150;
            border_size = 4;
            border_color = "rgb(0C96F9)";
            rounding = -1; # Negative means circle
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(CFE6F4)";
            inner_color = "rgb(657DC2)";
            outer_color = "rgb(0D0E15)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };
  };

}
