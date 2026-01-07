{ pkgs, config, osConfig ? null, powerlineChars, ... }:

let
  # Get hostname from osConfig or fallback to /etc/hostname for standalone home-manager
  hostname = if osConfig != null then
    osConfig.networking.hostName
  else
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile /etc/hostname);
  isThinkpad = hostname == "thinkpad";
  isDeepspace = hostname == "deepspace";

  # Powerline configuration
  pl = config.programs.waybar.powerline;

  # Get cap characters based on config
  capStyle = powerlineChars.${pl.caps.style};
  capRight = if pl.caps.inverted then capStyle.left else capStyle.right;
  capLeft = if pl.caps.inverted then capStyle.right else capStyle.left;

  # Get separator characters based on config
  sepStyle = powerlineChars.${pl.separators.style};
  sepRight = if pl.separators.inverted then sepStyle.left else sepStyle.right;
  sepLeft = if pl.separators.inverted then sepStyle.right else sepStyle.left;

  # Center module characters (sep01 = right →, sep10 = left ←)
  centerStyle = if pl.center.use == "tails" then
    powerlineChars.${pl.caps.style}
  else
    sepStyle;
  center01 = centerStyle.right; # points right →
  center10 = centerStyle.left; # points left ←

  # Center module names based on config
  centerLeftName = if pl.center.use == "tails" then
    (if pl.center.inverted then "custom/tails01" else "custom/tails10")
  else
    (if pl.center.inverted then "custom/sep01" else "custom/sep10");
  centerRightName = if pl.center.use == "tails" then
    (if pl.center.inverted then "custom/tails10" else "custom/tails01")
  else
    (if pl.center.inverted then "custom/sep10" else "custom/sep01");
in {
  programs.waybar.settings = {
    mainBar = {
      reload_style_on_change = true;
      position = "top";
      mode = "dock";
      spacing = 0;

      modules-left = (if pl.enable then [ "custom/left-cap" ] else [ ])
        ++ [ "custom/power" ]
        ++ (if pl.enable then [ "custom/sep-12" ] else [ ]) ++ [ "cpu" ]
        ++ (if pl.enable then [ "custom/sep-23" ] else [ ]) ++ [ "memory" ]
        ++ (if pl.enable then [ "custom/sep-31" ] else [ ]) ++ [ "disk" ]
        ++ (if pl.enable then [ "custom/sep-12-l2" ] else [ ]) ++ [ "network" ]
        ++ (if isDeepspace && pl.enable then [ "custom/sep-23-l2" ] else [ ])
        ++ (if isDeepspace then [ "dwl/window" ] else [ ])
        ++ (if !isDeepspace && pl.enable then [ "custom/sep-2T" ] else [ ])
        ++ (if isDeepspace && pl.enable then [ "custom/sep-31-l2" ] else [ ])
        ++ (if isDeepspace then [ "custom/monitor-toggle" ] else [ ])
        ++ (if isDeepspace && pl.enable then [ "custom/sep-1T" ] else [ ]);

      modules-center = (if pl.enable then [ "custom/sep-T2-l" ] else [ ])
        ++ [ "ext/workspaces" ]
        ++ (if pl.enable then [ "custom/sep-T2-r" ] else [ ]);

      modules-right = [
        "tray"
      ]
      # Right to left: sep-XY means bg=X, fg=Y
      # Deepspace: sep-T1 -> volume(1) -> sep-31-r -> weather(3) -> sep-32-r -> date(2) -> sep-21-r -> clock(1)
      # Thinkpad: sep-T3 -> bluetooth(3) -> sep-32 -> volume(2) -> sep-21-r -> weather(1) -> sep-13-r -> battery(3) -> sep-32-r -> date(2) -> sep-21-r2 -> clock(1)
        ++ (if isDeepspace && pl.enable then [ "custom/sep-T1" ] else [ ])
        ++ (if isThinkpad && pl.enable then [ "custom/sep-T3" ] else [ ])
        ++ (if isThinkpad then [ "bluetooth" ] else [ ])
        ++ (if isThinkpad && pl.enable then [ "custom/sep-32" ] else [ ])
        ++ (if isDeepspace && pl.enable then [ ] else [ ])
        ++ [ "pulseaudio" ]
        ++ (if isDeepspace && pl.enable then [ "custom/sep-31-r" ] else [ ])
        ++ (if isThinkpad && pl.enable then [ "custom/sep-21-r" ] else [ ])
        ++ [ "custom/weather" ]
        ++ (if isThinkpad && pl.enable then [ "custom/sep-13-r" ] else [ ])
        ++ (if isThinkpad then [ "battery" ] else [ ])
        ++ (if pl.enable then [ "custom/sep-32-r" ] else [ ])
        ++ [ "custom/date" ]
        ++ (if pl.enable then [ "custom/sep-21-r2" ] else [ ]) ++ [ "clock" ]
        ++ (if pl.enable then [ "custom/right-cap" ] else [ ]);

      # Workspaces
      "ext/workspaces" = {
        format = "{icon}";
        active-only = false;
        ignore-hidden = false;
        on-click = "activate";
        on-click-right = "deactivate";
        sort-by-id = true;
        format-icons = {
          default = "";
          active = "";
          urgent = "󰀦";
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
          "CT" = " CTIL";
          "G" = "󰋁 GRID";
          "K" = " DECK";
          "M" = "󰍹 MONO";
          "RT" = " RTIL";
          "S" = " SCRL";
          "T" = " TILE";
          "VG" = "󰋁 VGRD";
          "VK" = " VDCK";
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
        format = " {:%H:%M}";
        format-alt = " {:%a %d |  %H:%M}";
        tooltip-format = ''
          <big>{:%b | %d | %Y}</big>

          <tt><small>{calendar}</small></tt>'';
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
        format = " {usage}%";
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        tooltip = true;
        tooltip-format = "min: {min_frequency}";
        on-click = "foot btop";
      };

      # Memory
      memory = {
        format = " {used:0.1f} GiB";
        tooltip-format = ''
          Mem: {used}/{total} GiB | {percentage}%
          Swap: {swapUsed}/{swapTotal} GiB | {swapPercentage}%'';
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        on-click = "foot btop";
      };

      # Disk
      disk = {
        interval = 3600;
        format = " {used}";
        tooltip-format = ''
          Available: {free} | {percentage_free}%
          Used: {used} | {percentage_used}%'';
      };

      # Temperature (host-aware)
      temperature = {
        interval = 5;
        critical-threshold = 80;
        format = "  {temperatureC}°C";
      } // (if isThinkpad then {
        hwmon-path =
          "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon2/temp1_input";
        input-filename = "temp1_input";
      } else
        { });

      # Backlight
      backlight = {
        format = "{percent}% {icon}";
        format-icons = [ "" "" "" "" "" "" "" "" "" ];
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
        format-plugged = "{icon} {capacity}% ";
        tooltip = true;
        tooltip-format = ''
          {timeTo}
          Health: {health}%
          Usage: {power:0.1f}W
          Cycles: {cycles}'';
        format-alt = "{icon} {time}";
        format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };

      # Network
      network = {
        format-wifi = "{icon} {signalStrength}%";
        format-ethernet = "{icon} | {bandwidthTotalBytes}";
        format-disconnected = " 󰤮 ";
        format-alt = "{icon} |  {bandwidthUpBytes} |  {bandwidthDownBytes}";
        format-icons = {
          wifi = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          ethernet = [ "󰈀" ];
        };
        tooltip-format = "{ifname} via {gwaddr} 󰊗";
        tooltip-format-wifi = ''
          {icon} {essid} ({signalStrength}%)
          IP: {ipaddr}
          Down:  {bandwidthDownBytes}
          Up:  {bandwidthUpBytes}'';
        tooltip-format-ethernet = ''
          IP: {ipaddr}
          Down:  {bandwidthDownBytes}
          Up:  {bandwidthUpBytes}'';
        tooltip-format-disconnected = "󰤮 Disconnected";
      };

      # Pulseaudio
      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = "󰝟 {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "foot wiremix";
      };

      # Power button
      "custom/power" = {
        format = " ⏻ ";
        tooltip = false;
        on-click =
          "wlogout -l ~/.config/mango/wlogout/layout -s ~/.config/mango/wlogout/style.css";
      };

      # Monitor toggle (HDMI-A-2)
      "custom/monitor-toggle" = {
        format = " 󰍺 ";
        tooltip = true;
        tooltip-format = "Left click: turn on | Right click: turn off";
        on-click =
          "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-2 --on --pos 5120,0";
        on-click-right =
          "${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-2 --off";
      };

      # Bluetooth
      bluetooth = {
        format = " {icon}";
        format-connected = " {device_alias}";
        format-connected-battery =
          " {device_alias} {device_battery_percentage}%";
        format-icons = {
          enabled = "";
          disabled = "󰂲";
          off = "󰂲";
          connected = "";
          discovering = "󰂰";
        };
        tooltip-format = ''
          {controller_alias}	{controller_address}

          {num_connections} connected'';
        tooltip-format-connected = ''
          {controller_alias}	{controller_address}

          {num_connections} connected

          {device_enumerate}'';
        tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
        tooltip-format-enumerate-connected-battery =
          "{device_alias}	{device_address}	{device_battery_percentage}%";
        on-click = "foot bluetui";
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

      # Left cap (start of left modules)
      "custom/left-cap" = {
        format = capLeft;
        tooltip = false;
      };

      # Right cap (end of right modules)
      "custom/right-cap" = {
        format = capRight;
        tooltip = false;
      };

      # Left end separators - to transparent (pointing right →)
      "custom/sep-1T" = {
        format = sepRight;
        tooltip = false;
      };

      "custom/sep-2T" = {
        format = sepRight;
        tooltip = false;
      };

      # Left-side separators (pointing right →)
      "custom/sep-12" = {
        format = sepRight;
        tooltip = false;
      };

      "custom/sep-23" = {
        format = sepRight;
        tooltip = false;
      };

      "custom/sep-31" = {
        format = sepRight;
        tooltip = false;
      };

      # Left-side separators second cycle (l2)
      "custom/sep-12-l2" = {
        format = sepRight;
        tooltip = false;
      };

      "custom/sep-23-l2" = {
        format = sepRight;
        tooltip = false;
      };

      "custom/sep-31-l2" = {
        format = sepRight;
        tooltip = false;
      };

      # Right-side separators (pointing left ←)
      # Transparent to color (start of right modules)
      "custom/sep-T1" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-T2" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-T3" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-21" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-32" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-13" = {
        format = sepLeft;
        tooltip = false;
      };

      # Right-side separators (pointing left ←)
      "custom/sep-13-r" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-21-r" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-21-r2" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-31-r" = {
        format = sepLeft;
        tooltip = false;
      };

      "custom/sep-32-r" = {
        format = sepLeft;
        tooltip = false;
      };

      # Center separators (for workspace module)
      "custom/sep-T2-l" = {
        format = sepLeft; # points left ←
        tooltip = false;
      };

      "custom/sep-T2-r" = {
        format = sepRight; # points right →
        tooltip = false;
      };

    };
  };
}
