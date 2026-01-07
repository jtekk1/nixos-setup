{ config, lib, pkgs, ... }:

# Desktop launchers for TUI applications
# These show up in wofi/app launchers
{
  home.packages = [
    (pkgs.makeDesktopItem {
      name = "btop";
      desktopName = "Btop";
      comment = "System Monitor";
      icon = "utilities-system-monitor";
      exec = "foot -T BTOP btop";
      categories = [ "System" "Monitor" ];
      terminal = false;
    })

    (pkgs.makeDesktopItem {
      name = "gdu";
      desktopName = "GDU";
      comment = "Disk Usage Analyzer";
      icon = "drive-harddisk";
      exec = "foot -T GDU gdu";
      categories = [ "System" "Utility" ];
      terminal = false;
    })

    (pkgs.makeDesktopItem {
      name = "impala";
      desktopName = "Impala";
      comment = "Network Manager";
      icon = "network-wireless";
      exec = "foot -T IMPALA impala";
      categories = [ "Network" "System" ];
      terminal = false;
    })

    (pkgs.makeDesktopItem {
      name = "wiremix";
      desktopName = "Wiremix";
      comment = "Audio Mixer";
      icon = "audio-volume-high";
      exec = "foot -T WIREMIX wiremix";
      categories = [ "Audio" "Mixer" ];
      terminal = false;
    })

    (pkgs.makeDesktopItem {
      name = "bluetui";
      desktopName = "Bluetui";
      comment = "Bluetooth Manager";
      icon = "bluetooth";
      exec = "foot -T BTUI bluetui";
      categories = [ "Network" "System" ];
      terminal = false;
    })

    (pkgs.makeDesktopItem {
      name = "superfile";
      desktopName = "Superfile";
      comment = "File Manager";
      icon = "system-file-manager";
      exec = "kitty -e superfile";
      categories = [ "System" "FileManager" ];
      terminal = false;
    })
  ];
}
