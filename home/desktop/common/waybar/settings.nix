{ pkgs, config, osConfig ? null, ... }:

let
  hostname = if osConfig != null then osConfig.networking.hostName else "unknown";
  isThinkpad = hostname == "thinkpad";
  isDeepspace = hostname == "deepspace";
in {
  programs.waybar.settings = {
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
        "network"
        "dwl/window"
      ] ++ (if isDeepspace then [ "custom/monitor-toggle" ] else []);

      modules-center = [
        "ext/workspaces"
      ];

      modules-right = [
        "tray"
        "bluetooth"
        "pulseaudio"
        "custom/weather"
        "custom/date"
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

      # Battery (thinkpad only)
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

      # Monitor toggle (HDMI-A-2)
      "custom/monitor-toggle" = {
        format = " 󰍺 ";
        tooltip = true;
        tooltip-format = "Left click: turn on | Right click: turn off";
        on-click = "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-2 --on --pos 5120,0";
        on-click-right = "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-2 --off";
      };

      # Bluetooth
      bluetooth = {
        format = " {icon}";
        format-connected = " {device_alias}";
        format-connected-battery = " {device_alias} {device_battery_percentage}%";
        format-icons = {
          enabled = "";
          disabled = "󰂲";
          off = "󰂲";
          connected = "";
          discovering = "󰂰";
        };
        tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        on-click = "blueberry";
      };

      # Weather (custom script)
      "custom/weather" = {
        format = "{}";
        return-type = "json";
        interval = 900;
        exec = "status-weather";
        tooltip = true;
      };

      # Date (separate from clock)
      "custom/date" = {
        format = "󰃭 {}";
        interval = 60;
        exec = "date +'%a-%d'";
        tooltip = true;
        tooltip-format = "{}";
      };
    };
  };
}
