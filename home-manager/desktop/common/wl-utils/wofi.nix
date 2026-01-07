{ config, lib, pkgs, ... }:

{
  # Wofi - Application launcher for Wayland
  home.packages = with pkgs; [
    wofi
    cliphist  # For clipboard history
    jq        # For JSON processing in scripts
    wl-clipboard  # For clipboard operations
  ];

  # Main wofi configuration
  xdg.configFile."wofi/config" = {
    enable = true;
    text = ''
      # Window geometry and appearance
      width=300
      height=400
      location=center
      show=drun
      prompt=Search...
      filter_rate=100
      allow_markup=true
      no_actions=false
      halign=fill
      orientation=vertical
      content_halign=fill
      insensitive=true
      allow_images=true
      image_size=32
      gtk_dark=true
      dynamic_lines=true

      # Behavior
      hide_scroll=false
      matching=contains
      sort_order=default

      # Terminal
      term=kitty

      # Layout
      columns=1
      lines=10
    '';
  };

  # Wofi styling with theme colors
  xdg.configFile."wofi/style.css" = {
    enable = true;
    text = let
      colors = config.theme.colors;
    in ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
      }

      window {
        margin: 0px;
        border: 2px solid ${colors.accent_primary};
        border-radius: 10px;
        background-color: ${colors.rgba.bg_primary 0.95};
        animation: slideIn 0.15s ease-in-out;
      }

      #input {
        margin: 10px;
        padding: 10px;
        border: 2px solid ${colors.accent_secondary};
        border-radius: 8px;
        background-color: ${colors.rgba.bg_secondary 0.9};
        color: ${colors.accent_secondary};
        font-weight: bold;
      }

      #input:focus {
        border-color: ${colors.accent_primary};
        box-shadow: 0 0 10px ${colors.rgba.accent_primary 0.5};
      }

      #inner-box {
        margin: 5px;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        padding: 5px;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        background-color: transparent;
      }

      #text {
        margin: 5px;
        color: ${colors.accent_secondary};
      }

      #entry {
        margin: 3px;
        padding: 8px;
        border-radius: 6px;
        background-color: rgba(0, 0, 0, 0.3);
      }

      #entry:selected {
        background: linear-gradient(90deg, ${colors.rgba.accent_primary 0.3} 0%, ${colors.rgba.accent_secondary 0.3} 100%);
        border: 1px solid ${colors.accent_primary};
        color: ${colors.fg_primary};
        font-weight: bold;
      }

      #text:selected {
        color: ${colors.fg_primary};
      }

      @keyframes slideIn {
        from {
          opacity: 0;
          transform: translateY(-30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
    '';
  };

  # Create wofi menu scripts directory
  home.file.".local/bin/wofi-power-menu" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Power menu options with icons
      options="󰌾 Lock
      󰍃 Logout
      󰒲 Suspend
      󰜉 Reboot
      󰐥 Shutdown"

      # Show menu and get selection
      chosen=$(echo -e "$options" | wofi --dmenu --prompt="Power Menu" --cache-file=/dev/null --lines 5 --width 200)

      # Execute based on selection
      case $chosen in
          "󰌾 Lock")
              swaylock
              ;;
          "󰍃 Logout")
              # Handle logout based on compositor
              case "$XDG_CURRENT_DESKTOP" in
                  mango)
                      # Gracefully stop mango to release GPU/DRM resources
                      systemctl --user stop graphical-session.target 2>/dev/null
                      pkill -SIGTERM mango
                      ;;
                  *)
                      loginctl terminate-user $USER
                      ;;
              esac
              ;;
          "󰒲 Suspend")
              systemctl suspend
              ;;
          "󰜉 Reboot")
              systemctl reboot
              ;;
          "󰐥 Shutdown")
              systemctl poweroff
              ;;
      esac
    '';
  };

  home.file.".local/bin/wofi-clipboard-menu" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Get clipboard history from cliphist
      selected=$(cliphist list | wofi --dmenu --prompt="Clipboard" --lines=15)

      # If something was selected, decode and copy it
      if [ -n "$selected" ]; then
          echo "$selected" | cliphist decode | wl-copy
      fi
    '';
  };

  # Enable cliphist service for clipboard history
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history service";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
