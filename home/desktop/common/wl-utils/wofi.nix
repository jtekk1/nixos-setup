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
              hyprlock
              ;;
          "󰍃 Logout")
              # Handle logout based on compositor
              if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
                  hyprctl dispatch exit
              else
                  loginctl terminate-user $USER
              fi
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

  home.file.".local/bin/wofi-window-switcher" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Function to get windows based on compositor
      get_windows() {
          if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
              # Get Hyprland windows
              hyprctl clients -j | jq -r '.[] |
                  "[\(.workspace.name)] \(.class) - \(.title)" +
                  " [address:\(.address)]"'
          elif command -v swaymsg &> /dev/null; then
              # Fallback for sway-compatible compositors
              swaymsg -t get_tree | jq -r '
                  .. | select(.type? == "con" and .name? != null) |
                  "[\(.workspace)] \(.app_id // .window_properties.class) - \(.name)"'
          else
              echo "Window switching not supported for this compositor"
              exit 1
          fi
      }

      # Show window list and get selection
      selected=$(get_windows | wofi --dmenu --prompt="Windows" --lines=10)

      # Focus the selected window
      if [ -n "$selected" ]; then
          if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
              # Extract address from selection
              address=$(echo "$selected" | grep -o '\[address:0x[0-9a-f]*\]' |
                        sed 's/\[address://;s/\]//')
              if [ -n "$address" ]; then
                  hyprctl dispatch focuswindow "address:$address"
              fi
          elif command -v swaymsg &> /dev/null; then
              # Extract window ID for sway
              window_id=$(echo "$selected" | sed 's/.*\[\([0-9]*\)\].*/\1/')
              swaymsg "[con_id=$window_id]" focus
          fi
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
