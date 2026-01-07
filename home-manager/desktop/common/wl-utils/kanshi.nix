{ config, lib, pkgs, osConfig ? null, ... }:

let
  hostname = if osConfig != null then osConfig.networking.hostName else "unknown";
  isThinkpad = hostname == "thinkpad";
in {
  # Only enable kanshi on thinkpad
  services.kanshi = lib.mkIf isThinkpad {
    enable = true;
    systemdTarget = "graphical-session.target";

    settings = [
      {
        profile.name = "laptop-only";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-2";
            status = "enable";
            mode = "2560x1080@60Hz";
            position = "0,0";
          }
        ];
      }
    ];
  };
}
