{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.wallpaper;
in
{
  options.programs.wallpaper = {
    enable = mkEnableOption "wallpaper management with swww";

    autoRotate = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable automatic wallpaper rotation";
      };

      interval = mkOption {
        type = types.str;
        default = "15min";
        description = "Systemd timer interval for wallpaper rotation (e.g., 15min, 30min, 1h)";
      };

      mode = mkOption {
        type = types.enum [ "next" "random" "time" ];
        default = "next";
        description = "Mode for automatic wallpaper rotation";
      };
    };

    directories = mkOption {
      type = types.listOf types.str;
      default = [
        "/home/jtekk/NixSetups/home/assets/backgrounds"
        "~/Pictures/bluefin-dinos"
        "~/Pictures/backgrounds"
        "~/Pictures/wallpapers"
      ];
      description = "Directories to search for wallpapers";
    };
  };

  config = mkIf cfg.enable {
    # Install swww package
    home.packages = with pkgs; [
      swww
    ];

    # Systemd service for swww daemon
    systemd.user.services.swww-daemon = {
      Unit = {
        Description = "Swww wallpaper daemon";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Systemd service to restore wallpaper on startup
    systemd.user.services.wallpaper-restore = {
      Unit = {
        Description = "Restore current wallpaper on startup";
        After = [ "swww-daemon.service" ];
        Requires = [ "swww-daemon.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'if [ -f $HOME/.config/wallpaper/current ]; then unified-wallpaper --set \"$(cat $HOME/.config/wallpaper/current)\"; else unified-wallpaper; fi'";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Systemd service for wallpaper rotation
    systemd.user.services.wallpaper-rotate = mkIf cfg.autoRotate.enable {
      Unit = {
        Description = "Rotate wallpaper";
        After = [ "swww-daemon.service" "wallpaper-restore.service" ];
        Requires = [ "swww-daemon.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = let
          modeFlag = {
            "next" = "";
            "random" = "--random";
            "time" = "--time";
          }.${cfg.autoRotate.mode};
        in "${pkgs.bash}/bin/bash -c 'unified-wallpaper ${modeFlag}'";
      };
    };

    # Systemd timer for wallpaper rotation
    systemd.user.timers.wallpaper-rotate = mkIf cfg.autoRotate.enable {
      Unit = {
        Description = "Timer for wallpaper rotation";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Timer = {
        OnBootSec = "1min";
        OnUnitActiveSec = cfg.autoRotate.interval;
        Persistent = true;
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    # Create initial wallpaper config directory
    home.activation.createWallpaperConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.config/wallpaper
    '';
  };
}