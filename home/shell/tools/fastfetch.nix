{ config, pkgs, home-manager, ... }:

let colors = config.theme.colors;
in {
  home.packages = [ pkgs.fastfetch ];

  home.file.".config/fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" =
      "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
    logo = {
      type = "auto";
      source = "~/.config/fastfetch/jtekk.txt";
      color = {
        "1" = colors.accent_primary;
        "2" = colors.accent_secondary;
        "3" = colors.accent_tertiary;
        "4" = "";
        "5" = "";
        "6" = "";
        "7" = "";
        "8" = "";
        "9" = "";
      };
      width = null;
      height = null;
      padding = {
        top = 0;
        left = 0;
        right = 4;
      };
      printRemaining = true;
      preserveAspectRatio = false;
      recache = false;
      position = "left";
    };
    display = {
      stat = false;
      pipe = false;
      showErrors = false;
      disableLinewrap = true;
      hideCursor = false;
      separator = "  ";
      color = {
        keys = colors.accent_primary;
        title = colors.accent_secondary;
        output = colors.fg_primary;
        separator = colors.accent_tertiary;
      };
      brightColor = true;
      duration = {
        abbreviation = false;
        spaceBeforeUnit = "default";
      };
      size = {
        maxPrefix = "YB";
        binaryPrefix = "iec";
        ndigits = 2;
        spaceBeforeUnit = "default";
      };
      percent = {
        type = [ "num" "num-color" ];
        ndigits = 0;
        color = {
          green = "32";
          yellow = "93";
          red = "91";
        };
        spaceBeforeUnit = "default";
        width = 0;
      };
      fraction = { ndigits = 2; };
      noBuffer = false;
      key = {
        width = 12;
        type = "both";
        paddingLeft = 0;
      };
      freq = {
        ndigits = 2;
        spaceBeforeUnit = "default";
      };
      constants = [ ];
    };
    general = {
      thread = true;
      processingTimeout = 5000;
      detectVersion = true;
      playerName = "";
      dsForceDrm = false;
    };
    modules = [
      "break"
      {
        type = "custom";
        outputColor = colors.accent_secondary;
        keyIcon = "";
        format = " ┌───────────────── Hardware ─────────────────┐";
      }
      {
        type = "host";
        key = " 󰪫 PC ";
        keyIcon = "";
        keyColor = colors.accent_secondary;
        format = "Custom Built";
      }
      {
        type = "chassis";
        key = "   ├󰇅 ";
        keyIcon = "";
        keyColor = colors.accent_secondary;
        format = "ThermalTake 600";
      }
      {
        type = "board";
        key = "   ├ ";
        keyIcon = "";
        keyColor = colors.accent_secondary;
        format = "{1}";
      }
      {
        type = "cpu";
        key = "   ├ ";
        keyIcon = "";
        keyColor = colors.accent_secondary;
        format = "{1}";
      }
      {
        type = "gpu";
        key = "   ├󰢮 ";
        keyIcon = "";
        keyColor = colors.accent_secondary;
        format = "{2}";
      }
      {
        type = "memory";
        key = "   ├ ";
        keyIcon = "";
        keyColor = colors.accent_secondary;
        format = "{1} / {2} ({3})";
      }
      {
        type = "disk";
        key = "   ├ ";
        keyIcon = "";
        keyColor = colors.accent_secondary;
        format = "{1} / {2} ({3}) [{9}]";
      }
      {
        type = "custom";
        outputColor = colors.accent_secondary;
        keyIcon = "";
        format = " └────────────────────────────────────────────┘";
      }
      "break"
      "break"
      {
        type = "custom";
        outputColor = colors.accent_primary;
        keyIcon = "";
        format = " ┌───────────────── Software ─────────────────┐";
      }
      {
        type = "os";
        key = "  OS ";
        keyIcon = "";
        keyColor = colors.accent_primary;
        format = "{3}";
      }
      {
        type = "kernel";
        key = "   ├󰒓 ";
        keyIcon = "";
        keyColor = colors.accent_primary;
        format = "{1} {2} | {4}";
      }
      {
        type = "packages";
        key = "   ├󰏔 ";
        keyIcon = "";
        keyColor = colors.accent_primary;
        format = "{1} Packages";
      }
      "break"
      {
        type = "wm";
        key = " 󰧨 WM ";
        keyIcon = "";
        keyColor = colors.accent_primary;
      }
      {
        type = "de";
        key = " 󰧨 DE ";
        keyIcon = "";
        keyColor = colors.accent_primary;
      }
      {
        type = "terminal";
        key = "   ├ ";
        format = "{1}: {6}";
        keyIcon = "";
        keyColor = colors.accent_primary;
      }
      {
        type = "shell";
        key = "   ├ ";
        format = "{1}: {4}";
        keyIcon = "";
        keyColor = colors.accent_primary;
      }
      {
        type = "custom";
        outputColor = colors.accent_primary;
        keyIcon = "";
        format = " └────────────────────────────────────────────┘";
      }
      "break"
      "break"
      {
        type = "custom";
        outputColor = colors.accent_tertiary;
        keyIcon = "";
        format = " ┌─────────────────── MISC ───────────────────┐";
      }
      {
        type = "custom";
        key = " TIME ";
        keyIcon = "";
        keyColor = colors.accent_tertiary;
      }
      {
        type = "uptime";
        keyIcon = "";
        key = "   ├󰔛 ";
        keyColor = colors.accent_tertiary;
        format = "{1} Day(s), {2} Hours, {3} Minutes";
      }
      {
        type = "command";
        key = "   ├󱦟 ";
        keyIcon = "";
        keyColor = colors.accent_tertiary;
        text =
          "birth_install=$(stat -c %W /); current=$(date +%s); days_difference=$(( (current - birth_install) / 86400 )); echo $days_difference days";
      }
      {
        type = "command";
        key = "   ├ ";
        keyIcon = "";
        keyColor = colors.accent_tertiary;
        text =
          "birth_install=$(stat -c %W /); echo $(date -d @$birth_install '+%d %b %Y')";
      }
      {
        type = "custom";
        outputColor = colors.accent_tertiary;
        keyIcon = "";
        format = " └────────────────────────────────────────────┘";
      }
    ];
  };

  home.file.".config/fastfetch/jtekk.txt".text = ''


      ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
      ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
      ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
      ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
      ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
      ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
              ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖
              ▜███▙       ▜███▙  ▟███▛
               ▜███▙       ▜███▙▟███▛
                ▜███▙       ▜██████▛
         ▟█████████████████▙ ▜████▛     ▟▙
        ▟███████████████████▙ ▜███▙    ▟██▙
               ▄▄▄▄▖           ▜███▙  ▟███▛
              ▟███▛             ▜██▛ ▟███▛
             ▟███▛               ▜▛ ▟███▛
    ▟███████████▛                  ▟██████████▙
    ▜██████████▛                  ▟███████████▛
          ▟███▛ ▟▙               ▟███▛
         ▟███▛ ▟██▙             ▟███▛
        ▟███▛  ▜███▙           ▝▀▀▀▀
        ▜██▛    ▜███▙ ▜██████████████████▛
         ▜▛     ▟████▙ ▜████████████████▛
               ▟██████▙       ▜███▙
              ▟███▛▜███▙       ▜███▙
             ▟███▛  ▜███▙       ▜███▙

         ██╗████████╗███████╗██╗  ██╗██╗  ██╗
         ██║╚══██╔══╝██╔════╝██║ ██╔╝██║ ██╔╝
         ██║   ██║   █████╗  █████╔╝ █████╔╝
    ██   ██║   ██║   ██╔══╝  ██╔═██╗ ██╔═██╗
    ╚█████╔╝   ██║   ███████╗██║  ██╗██║  ██╗
     ╚════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
  '';
}
