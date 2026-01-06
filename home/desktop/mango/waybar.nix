{ pkgs, config, osConfig ? null, ... }:

let
  colors = config.theme.colors;
  hostname = if osConfig != null then osConfig.networking.hostName else "unknown";
  isThinkpad = hostname == "thinkpad";

  # Theme colors with fallbacks
  primaryColor = if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null
                 then colors.mangoOverrides.focuscolor
                 else colors.accent_primary;
  urgentColor = if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null
                then colors.mangoOverrides.urgentcolor
                else colors.accent_secondary;
in {
  programs.waybar = {
    enable = true;
    systemd.enable = false;  # Waybar started manually via toggle-waybar or autostart

    settings = {
      mainBar = {
        reload_style_on_change = true;
        position = "top";
        mode = "dock";
        spacing = 0;

        modules-left = [
          "custom/power"
          "cpu"
          "memory"
          "disk"
          "temperature"
          "dwl/window"
        ];

        modules-center = [
          "ext/workspaces"
        ];

        modules-right = [
          "tray"
          "mpd"
          "idle_inhibitor"
          "keyboard-state"
          "pulseaudio"
          "network"
        ] ++ (if isThinkpad then [ "battery" ] else [])
          ++ [ "clock" ];

        # Workspaces
        "ext/workspaces" = {
          format = "{icon}";
          active-only = false;
          ignore-hidden = false;
          on-click = "activate";
          on-click-right = "deactivate";
          sort-by-id = true;
          format-icons = {
            default = "";
            active = "";
            urgent = "";
          };
        };

        # Window/Layout display with menu
        "dwl/window" = {
          format = "{layout}";
          menu = "on-click";
          menu-file = "$HOME/.config/waybar/mango-menu.xml";
          menu-actions = {
            tiling = "mmsg -l T";
            tgmix = "mmsg -l TG";
            centerTiling = "mmsg -l CT";
            rightTiling = "mmsg -l RT";
            verticalTiling = "mmsg -l VT";
            scrolling = "mmsg -l S";
            verticalScrolling = "mmsg -l VS";
            grid = "mmsg -l G";
            verticalGrid = "mmsg -l VG";
            deck = "mmsg -l K";
            verticalDeck = "mmsg -l VK";
            monocle = "mmsg -l M";
          };
          rewrite = {
            "TG" = "󰨇 TGMX";
            "CT" = " CTIL";
            "G" = "󰋁 GRID";
            "K" = " DECK";
            "M" = "󰍹 MONO";
            "RT" = " RTIL";
            "S" = " SCRL";
            "T" = " TILE";
            "VG" = "󰋁 VGRD";
            "VK" = " VDCK";
            "VS" = "󰽿 VSCR";
            "VT" = "󱂩 VTIL";
          };
        };

        # Keyboard state
        keyboard-state = {
          numlock = true;
          capslock = true;
          scrolllock = true;
          format = {
            numlock = "  {icon} ";
            capslock = " 󰪛 {icon} ";
            scrolllock = " 󰹹 {icon} ";
          };
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        # MPD
        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 5;
          consume-icons = { on = " "; };
          random-icons = { off = "<span color=\"#f53c3c\"></span> "; on = " "; };
          repeat-icons = { on = " "; };
          single-icons = { on = "1 "; };
          state-icons = { paused = ""; playing = ""; };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        # Idle inhibitor
        idle_inhibitor = {
          format = "idle: {icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        # System tray
        tray = {
          icon-size = 21;
          spacing = 10;
        };

        # Clock
        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%a %d |  %H:%M}";
          tooltip-format = "<big>{:%b | %d | %Y}</big>\n\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        # CPU
        cpu = {
          format = " {usage}%";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          tooltip = true;
          tooltip-format = "min: {min_frequency}";
          on-click = "foot btop";
        };

        # Memory
        memory = {
          format = " {used:0.1f} GiB";
          tooltip-format = "Mem: {used}/{total} GiB | {percentage}%\nSwap: {swapUsed}/{swapTotal} GiB | {swapPercentage}%";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          on-click = "foot btop";
        };

        # Disk
        disk = {
          interval = 3600;
          format = " {used}";
          tooltip-format = "Available: {free} | {percentage_free}%\nUsed: {used} | {percentage_used}%";
        };

        # Temperature (host-aware)
        temperature = {
          interval = 5;
          critical-threshold = 80;
          format = "  {temperatureC}°C";
          format-icons = ["" "" ""];
        } // (if isThinkpad then {
          hwmon-path = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon2/temp1_input";
          input-filename = "temp1_input";
        } else {});

        # Backlight
        backlight = {
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };

        # Battery (thinkpad only, conditionally added to modules-right)
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "{icon} {capacity}% 󱊦";
          format-plugged = "{icon} {capacity}% ";
          tooltip = true;
          tooltip-format = "{timeTo}\nHealth: {health}%\nUsage: {power:0.1f}W\nCycles: {cycles}";
          format-alt = "{icon} {time}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        # Power profiles
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        # Network
        network = {
          format-wifi = "{icon} {signalStrength}%";
          format-ethernet = "{icon} | {bandwidthTotalBytes}";
          format-disconnected = " 󰤮 ";
          format-alt = "{icon} |  {bandwidthUpBytes} |  {bandwidthDownBytes}";
          format-icons = {
            wifi = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            ethernet = ["󰈀"];
          };
          tooltip-format = "{ifname} via {gwaddr} 󰊗";
          tooltip-format-wifi = "{icon} {essid} ({signalStrength}%)\nIP: {ipaddr}\nDown:  {bandwidthDownBytes}\nUp:  {bandwidthUpBytes}";
          tooltip-format-ethernet = "IP: {ipaddr}\nDown:  {bandwidthDownBytes}\nUp:  {bandwidthUpBytes}";
          tooltip-format-disconnected = "󰤮 Disconnected";
        };

        # Pulseaudio
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "󰝟 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "foot wiremix";
        };

        # Power button
        "custom/power" = {
          format = " ⏻ ";
          tooltip = false;
          on-click = "wlogout -l ~/.config/wlogout/layout -s ~/.config/wlogout/style.css";
        };
      };
    };

    style = ''
      * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: CaskaydiaCove Nerd Font Propo, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        font-size: 11px;
      }

      window#waybar {
        background-color: ${colors.rgba.bg_primary 1.0};
        border-bottom: 2px solid ${primaryColor};
      }

      #pulseaudio:hover {
        background-color: ${primaryColor};
      }

      #workspaces,
      #workspaces button {
        background: transparent;
        border: 0;
        border-radius: 20px;
        opacity: 1.0;
        padding: 0 2px;
        box-shadow: none;
        border: none;
        outline: none;
        text-shadow: none;
        animation: none;
        color: ${colors.fg_dim};
      }

      #workspaces button.hidden {
        opacity: 0.2;
      }

      #workspaces button.active {
        transition: ease-in 300ms;
        opacity: 1.0;
        color: ${primaryColor};
      }

      #workspaces button.urgent {
        background-color: ${urgentColor};
      }

      #window,
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-power,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #keyboard-state,
      #mpd {
        padding: 0 10px;
        color: ${primaryColor};
        border-right: 1px solid rgba(255,255,255,0.2);
      }

      #clock {
        border-right: none;
      }

      #idle_inhibitor {
        border-left: 1px solid rgba(255,255,255,0.2);
      }

      #battery.charging {
        color: #ffffff;
        background-color: ${primaryColor};
      }
    '';
  };

  # Mango menu XML for layout switching
  xdg.configFile."waybar/mango-menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkMenu" id="menu">
        <child>
          <object class="GtkMenuItem" id="tiling">
            <property name="label"> Tiling</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="tgmix">
            <property name="label">󰨇 TG Mix</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="centerTiling">
            <property name="label"> Center Tiling</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="rightTiling">
            <property name="label"> Right Tiling</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="verticalTiling">
            <property name="label">󱂩 Vertical Tiling</property>
          </object>
        </child>
        <child>
          <object class="GtkSeparatorMenuItem" id="delimiter1" />
        </child>
        <child>
          <object class="GtkMenuItem" id="scrolling">
            <property name="label"> Scrolling</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="verticalScrolling">
            <property name="label">󰽿 Vertical Scrolling</property>
          </object>
        </child>
        <child>
          <object class="GtkSeparatorMenuItem" id="delimiter2" />
        </child>
        <child>
          <object class="GtkMenuItem" id="grid">
            <property name="label">󰋁 Grid</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="verticalGrid">
            <property name="label">󰋁 Vertical Grid</property>
          </object>
        </child>
        <child>
          <object class="GtkSeparatorMenuItem" id="delimiter3" />
        </child>
        <child>
          <object class="GtkMenuItem" id="deck">
            <property name="label"> Deck</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="verticalDeck">
            <property name="label"> Vertical Deck</property>
          </object>
        </child>
        <child>
          <object class="GtkSeparatorMenuItem" id="delimiter4" />
        </child>
        <child>
          <object class="GtkMenuItem" id="monocle">
            <property name="label">󰍹 Monocle</property>
          </object>
        </child>
      </object>
    </interface>
  '';
}
