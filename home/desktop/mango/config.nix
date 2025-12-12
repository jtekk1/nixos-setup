{ config, pkgs, ... }:

{
  # Additional Mango WM configuration settings can be added here
  # Most configuration is handled through the settings string in bindings.nix
  # This file can be used for any extra configuration that doesn't fit in the main settings

  # Enable Mango WM for this user
  wayland.windowManager.mango = {
    enable = true;
    # Enable systemd integration for desktop apps
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
    # Run autostart script (no longer called automatically in latest mango)
    settings = ''
      exec-once=~/.config/mango/autostart.sh
    '';
  };

  # Enable additional Wayland programs
  programs.wlogout.enable = true;

  # Enable unified wallpaper management
  programs.wallpaper = {
    enable = true;
    autoRotate = {
      enable = true;
      interval = "30min"; # Match the previous bluefin rotation interval
      mode = "next"; # Can be "next", "random", or "time"
    };
  };

  # Old bluefin-wallpaper-rotate service replaced by unified wallpaper management above

  # GTK theme is configured in wayland-common/theme.nix (shared across all wayland desktops)

  # Home packages specific to Mango WM
  home.packages = with pkgs; [
    # Qt5 Configuration Tool (required for QT_QPA_PLATFORMTHEME=qt5ct)
    libsForQt5.qt5ct

    # GNOME wallpapers for theming consistency
    gnome-backgrounds

    # Additional utilities
    jq
    socat
    ripgrep
    fd
  ];
}
