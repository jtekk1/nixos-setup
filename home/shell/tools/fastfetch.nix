{ config, pkgs, home-manager, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  home.file.".config/fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
    logo = {
      type = "auto";
      source = "~/.config/fastfetch/jtekk.txt";
      color = {
        "1" = "blue";
        "2" = "white";
        "3" = "red";
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
      separator = "  ";
      color = {
        keys = "";
        title = "";
        output = "";
        separator = "yellow";
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
        type = [
          "num"
          "num-color"
        ];
        ndigits = 0;
        color = {
          green = "32";
          yellow = "93";
          red = "91";
        };
        spaceBeforeUnit = "default";
        width = 0;
      };
      fraction = {
        ndigits = 2;
      };
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
      constants = [];
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
        outputColor = "bright_cyan";
        keyIcon = "";
        format = " ┌───────────────── Hardware ─────────────────┐";
      }
      {
        type = "host";
        key = " 󰪫 PC ";
        keyIcon = "";
        keyColor = "cyan";
        format = "Custom Built";
      }
      {
        type = "chassis";
           key = "   ├󰇅 ";
        keyIcon = "";
        keyColor = "cyan";
        format = "ThermalTake 600";
      }
      {
        type = "board";
        key = "   ├ ";
        keyIcon = "";
        keyColor = "cyan";
        format = "{1}";
      }
      {
        type = "cpu";
        key = "   ├ ";
        keyIcon = "";
        keyColor = "cyan";
        format = "{1}";
      }
      {
        type = "gpu";
        key = "   ├󰢮 ";
        keyIcon = "";
        keyColor = "cyan";
        format = "{2}";
      }
      {
        type = "memory";
        key = "   ├ ";
        keyIcon = "";
        keyColor = "cyan";
        format = "{1} / {2} ({3})";
      }
      {
        type = "disk";
        key = "   ├ ";
        keyIcon = "";
        keyColor = "cyan";
        format = "{1} / {2} ({3}) [{9}]";
      }
      {
        type = "custom";
        outputColor = "bright_cyan";
        keyIcon = "";
        format = " └────────────────────────────────────────────┘";
      }
      "break"
      "break"
      {
        type = "custom";
        outputColor = "bright_blue";
        keyIcon = "";
        format = " ┌───────────────── Software ─────────────────┐";
      }
      {
        type = "os";
        key = "  OS ";
        keyIcon = "";
        keyColor = "blue";
        format = "{3}";
      }
      {
        type = "kernel";
        key = "   ├󰒓 ";
        keyIcon = "";
        keyColor = "blue";
        format = "{1} {2} | {4}";
      }
      {
        type = "packages";
        key = "   ├ ";
        keyIcon = "";
        keyColor = "blue";
        format = "{1} Packages";
      }
      "break"
      {
        type = "wm";
        key = " 󰧨 WM ";
        keyIcon = "";
        keyColor = "blue";
      }
      {
        type = "de";
        key = " 󰧨 DE ";
        keyIcon = "";
        keyColor = "blue";
      }
      {
        type = "terminal";
        key = "   ├ ";
        format = "{1}: {6}";
        keyIcon = "";
        keyColor = "blue";
      }
      {
        type = "shell";
        key = "   ├ ";
        format = "{1}: {4}";
        keyIcon = "";
        keyColor = "blue";
      }
      {
        type = "custom";
        outputColor = "bright_blue";
        keyIcon = "";
        format = " └────────────────────────────────────────────┘";
      }
      "break"
      "break"
      {
        type = "custom";
        outputColor = "bright_green";
        keyIcon = "";
        format = " ┌─────────────────── MISC ───────────────────┐";
      }
      {
        type = "custom";
        key = " TIME ";
        keyIcon = "";
        keyColor = "green";
      }
      {
        type = "uptime";
        keyIcon = "";
        key = "   ├󰔛 ";
        keyColor = "green";
        format = "{1} Day(s), {2} Hours, {3} Minutes";
      }
      {
        type = "command";
        key = "   ├󱦟 ";
        keyIcon = "";
        keyColor = "green";
        text = "birth_install=$(stat -c %W /); current=$(date +%s); days_difference=$(( (current - birth_install) / 86400 )); echo $days_difference days";
      }
      {
        type = "command";
        key = "   ├ ";
        keyIcon = "";
        keyColor = "green";
        text = "birth_install=$(stat -c %W /); echo $(date -d @$birth_install '+%d %b %Y')";
      }
      {
        type = "custom";
        outputColor = "bright_green";
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
