{ pkgs, config, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;  # Waybar is started by Mango's autostart script, not systemd

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
          "dwl/window"
          "custom/monitor-toggle"
        ];

        modules-center = [
          "ext/workspaces"
        ];

        modules-right = [
          "mpris"
          "group/tray"
          "bluetooth"
          "pulseaudio"
          "custom/weather"
          "clock"
        ];
	
        "dwl/window" = {
          format = "{layout}";
          rewrite = {
            "CT" = "CTILE";
            "RT" = "RTILE";
            "VT" = "VTILE";
            "T" = "TLING";
            "VS" = "VSCRL";
            "S" = "SCROL";
            "G" = "GRID-";
            "VG" = "VGRID";
            "K" = "DECK-";
            "VK" = "VDECK";
            "M" = "MONOC";
          };
          menu = "on-click";
          menu-file = "/home/jtekk/.config/waybar/mango-menu.xml";
          "menu-actions" = {
            "tiling" = "mmsg -l T";
            "centerTiling" = "mmsg -l CT";
            "rightTiling" = "mmsg -l RT";
            "verticalTiling" = "mmsg -l VT";
            "scrolling" = "mmsg -l S";
            "verticalScrolling" = "mmsg -l VS";
            "vrid" = "mmsg -l G";
            "verticalGrid" = "mmsg -l VG";
            "deck" = "mmsg -l K";
            "verticalDeck" = "mmsg -l VK";
            "monocle" = "mmsg -l M";
          };
          swap-icon-label = false;
        };

        "ext/workspaces" = {
          format = "{icon}";
          ignore-hidden = false;
          on-click = "activate";
          on-click-right = "deactivate";
          sort-by-id = true;
          format-icons = {
            "1" = "1: ";
            "2" = "2: ";
            "3" = "3: ";
            "4" = "4: 󰭹";
            "5" = "5: ";
            "6" = "6: ";
            "7" = "7: ";
            "8" = "8";
            "9" = "9";
          };
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
          format = "  {usage}%";
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon3/temp4_input";
          critical-threshold = 80;
          format = " {temperatureC}󰔄";
        };

        memory = {
          interval = 5;
          format = "  {used} / {percentage}%";
        };

        disk = {
          interval = 3600;
          format = "  {used} / {percentage_used}%";
          path = "/";
        };

        bluetooth = {
          format = " {status} ";
          format-disabled = "  󰂲  ";
          format-on = "    ";
          format-connected = "    ";
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

        "group/dwl-window" = {
          orientation = "inherit";
          modules = [
            "dwl/window"
          ];
        };

        "custom/taskbar-icon" = {
          format = "  󰨇  ";
        };

        "wlr/taskbar" = {
          format = "{icon}";
          all-outputs = false;
          tooltip-format = "{title}";
          markup = true;
          on-click = "activate";
          on-click-right = "close";
          ignore-list = [ "Rofi" "wofi" ];
          active-first = true;
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
	        format = "    ";
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
          format = "    ";
        };

        network = {
          interval = 2;
          format = "{icon}";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "  {bandwidthDownBytes} |   {bandwidthUpBytes}";
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
          format-muted = " ";
          on-click = "kitty --title=Wiremix wiremix";
          on-click-right = "pamixer -t";
          on-scroll-up = "pamixer -i 2";
          on-scroll-down = "pamixer -d 2";
          scroll-step = 5;
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
        };

        "pulseaudio/slider" = {
          "min" = 0;
          "max" = 100;
          "oritentation" = "horizontal";
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

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          tooltip = false;
          format-source-muted = " Muted";
          on-click = "pamixer --default-source -t";
          on-scroll-up = "pamixer --default-source -i 2";
          on-scroll-down = "pamixer --default-source -d 2";
          scroll-step = 5;
        };
      };
    };

    style = let
      colors = config.theme.colors;
      primaryColor = if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null
                     then colors.mangoOverrides.focuscolor
                     else colors.accent_primary;
      urgentColor = if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null
                    then colors.mangoOverrides.urgentcolor
                    else colors.accent_secondary;
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
      #taskbar,
      #clock,
      #pulseaudio,
      #pulseaudio-slider,
      #custom-power,
      #custom-weather,
      #custom-monitor-toggle,
      #custom-system-icon,
      #custom-taskbar-icon,
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

      #taskbar button.urgent {
        background-color: ${urgentColor};
        animation: urgent-blink 1s infinite;
      }

      #taskbar button.active {
        background-color: ${colors.rgba.accent_primary 0.95};
      }

      #pulseaudio-slider slider {
        min-height: 0px;
        min-width: 0px;
        opacity: 0;
        background-image: none;
        border: none;
        box-shadow: none;
      }

      #pulseaudio-slider trough {
        min-height: 10px;
        min-width: 80px;
        border-radius: 5px;
        background: black;
      }

      #pulseaudio-slider highlight {
        min-width: 10px;
        border-radius: 5px;
        background: white;
      }
    '';
  };

  xdg.configFile."waybar/mango-menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
        <object class="GtkMenu" id="menu">
            <child>
                <object class="GtkMenuItem" id="tiling">
                    <property name="label">  Tiling</property>
                </object>
            </child>
            <child>
                <object class="GtkMenuItem" id="centerTiling">
                    <property name="label">  Center Tiling</property>
                </object>
            </child>
            <child>
                <object class="GtkMenuItem" id="rightTiling">
                    <property name="label">  Right Tiling</property>
                </object>
            </child>
            <child>
                <object class="GtkMenuItem" id="verticalTiling">
                    <property name="label">  Vertical Tiling</property>
                </object>
            </child>
            <child>
                <object class="GtkSeparatorMenuItem" id="delimiter1" />
            </child>
            <child>
                <object class="GtkMenuItem" id="scrolling">
                    <property name="label">󰹳  Scrolling</property>
                </object>
            </child>
            <child>
                <object class="GtkMenuItem" id="verticalScrolling">
                    <property name="label">󰹹  Vertical Scrolling</property>
                </object>
            </child>
            <child>
                <object class="GtkSeparatorMenuItem" id="delimiter2" />
            </child>
            <child>
                <object class="GtkMenuItem" id="vrid">
                    <property name="label">󰋁  Grid</property>
                </object>
            </child>
            <child>
                <object class="GtkMenuItem" id="verticalGrid">
                    <property name="label">󰝘  Vertical Grid</property>
                </object>
            </child>
            <child>
                <object class="GtkSeparatorMenuItem" id="delimiter3" />
            </child>
            <child>
                <object class="GtkMenuItem" id="deck">
                    <property name="label">  Deck</property>
                </object>
            </child>
            <child>
                <object class="GtkMenuItem" id="verticalDeck">
                    <property name="label">  Vertical Deck</property>
                </object>
            </child>
            <child>
                <object class="GtkSeparatorMenuItem" id="delimiter4" />
            </child>
            <child>
                <object class="GtkMenuItem" id="monocle">
                    <property name="label">󰹑  Monocle</property>
                </object>
            </child>
        </object>
    </interface>
  '';
}
