{ pkgs, config, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;  # Disabled - Hyprland exec-once handles startup

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        ipc = false;
        reload_style_on_change = true;
        height = 36;

        modules-left = [
          "custom/power"
          "cpu"
          "memory"
          "disk"
          "network"
          "hyprland/window"
          "custom/monitor-toggle"
        ];

        modules-center = [
          "hyprland/workspaces"
        ];

        modules-right = [
          "mpris"
          "group/tray"
          "bluetooth"
          "pulseaudio"
          "custom/weather"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          sort-by-id = true;
          format-icons = {
            "1" = "1: ";
            "2" = "2: ";
            "3" = "3: ";
            "4" = "4: 󰭹";
            "5" = "5: ";
            "6" = "6: ";
            "7" = "7: ";
            "8" = "8";
            "9" = "9";
          };
          persistent-workspaces = { "*" = 7; };
        };

        "hyprland/window" = {
          format = "{class}";
          max-length = 50;
          separate-outputs = true;
        };

        "group/system" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
          };
          modules = [
            "custom/system-icon"
            "cpu"
            "temperature"
            "memory"
            "disk"
          ];
        };

        "custom/system-icon" = {
          format = "  󱎴  ";
        };

        cpu = {
          interval = 5;
          format = "  {usage}%";
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon3/temp4_input";
          critical-threshold = 80;
          format = " {temperatureC}󰔄";
        };

        memory = {
          interval = 5;
          format = "  {used} / {percentage}%";
        };

        disk = {
          interval = 3600;
          format = "  {used} / {percentage_used}%";
          path = "/";
        };

        bluetooth = {
          format = " {status} ";
          format-disabled = "  󰂲  ";
          format-on = "    ";
          format-connected = "    ";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueberry";
        };

        "custom/monitor-toggle" = {
          format = " 󰍺  ";
          tooltip = true;
          tooltip-format = "Left click: turn on | Right click: turn off";
          on-click = "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-2 --on --pos 5120,0";
          on-click-right = "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-2 --off";
        };

        mpris = {
          format = "{player_icon} - {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
            spotify = "󰓇 ";
          };
          status-icons = {
            paused = "⏸ ";
          };
          max-length = 70;
        };

        "group/tray" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
          };
          modules = [
            "custom/tray-icon"
            "tray"
          ];
        };

        "custom/tray-icon" = {
          format = "    ";
        };

        tray = {
          format = "{icon}";
          interval = 5;
          icon-size = 12;
          spacing = 5;
        };

        "group/network" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
          };
          modules = [
            "custom/network-icon"
            "network"
          ];
        };

        "custom/network-icon" = {
          format = "    ";
        };

        network = {
          interval = 2;
          format = "{icon}";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "  {bandwidthDownBytes} |   {bandwidthUpBytes}";
          format-linked = " No IP ({ifname})";
          format-disconnected = " Disconnected";
          tooltip-format = "{ifname} {ipaddr}/{cidr} via {gwaddr}";
        };

        clock = {
          format = "{:%a %d | 󰥔  %I:%M %p}";
          format-alt = "{:%A, %B %d, %Y - %I:%M %p}";
          tooltip = true;
          tooltip-format = "{:%A, %B %d %Y}";
          on-click = "if pgrep -x yad; then pkill -x yad; else yad --calendar --undecorated --no-buttons --close-on-unfocus; fi";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          tooltip = false;
          format-muted = " ";
          on-click = "kitty --title=Wiremix wiremix";
          on-click-right = "pamixer -t";
          on-scroll-up = "pamixer -i 2";
          on-scroll-down = "pamixer -d 2";
          scroll-step = 5;
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
        };

        "custom/power" = {
          format = "  ⏻  ";
          tooltip = false;
          on-click = "/home/jtekk/.local/bin/wofi-power-menu";
        };

        "custom/weather" = {
          format = "{text}";
          exec = "status-weather";
          return-type = "json";
          interval = 1800;  # Update every 30 minutes
          tooltip = true;
          on-click = "xdg-open 'https://wttr.in/brighton_co'";
        };
      };
    };

    style = let
      colors = config.theme.colors;
      primaryColor = colors.accent_primary;
      urgentColor = colors.accent_secondary;
    in ''
      * {
        font-family: "Noto Sans", "Font Awesome 7 Free";
        font-weight: 600;
        font-size: 14px;
        min-height: 0;
        border-radius: 0px;
      }

      window#waybar {
        background-color: rgba(15,15,15, 0.6);
        padding: 0px;
      }

      tooltip {
        background: rgba(44, 44, 44, 0.95);
        border-radius: 8px;
        border-width: 1px;
        border-style: solid;
        border-color: rgba(255, 255, 255, 0.1);
        color: #ffffff;
      }

      #group-tray,
      #group-network,
      #group-system {
        background-color: transparent;
        border: none;
        margin: 0px;
        padding: 0px;
      }

      #mpris,
      #network,
      #bluetooth,
      #disk,
      #memory,
      #cpu,
      #temperature,
      #clock,
      #pulseaudio,
      #custom-power,
      #custom-weather,
      #custom-monitor-toggle,
      #custom-system-icon,
      #custom-tray-icon,
      #custom-network-icon,
      #window,
      #workspaces {
        background-color: ${colors.rgba.accent_primary 0.95};
        border: 2px solid black;
        border-radius: 12px;
        margin-left: 0px;
        margin-right: 0px;
        padding-left: 8px;
        padding-right: 8px;
      }

      #workspaces button {
        transition: all 0.2s ease;
      }

      #workspaces button.hidden {
        color: ${colors.rgba.bg_primary 0.4};
      }

      #workspaces button.active {
        color: white;
        border-bottom: 2px solid white;
      }

      #workspaces button.visible {
        color: black;
      }

      #custom-power:hover,
      #custom-weather:hover,
      #custom-monitor-toggle:hover,
      #bluetooth:hover,
      #pulseaudio:hover,
      #window:hover,
      #workspaces button:hover {
        background-color: ${colors.rgba.bg_primary 0.65};
        color: #ffffff;
      }

      #workspaces button.urgent {
        background-color: ${urgentColor};
        color: #ffffff;
        animation: urgent-blink 1s infinite;
      }

      #mpris {
        margin-left: 400px;
      }

      @keyframes urgent-blink {
        from { opacity: 1; }
        to { opacity: 0.5; }
      }
    '';
  };
}
