{ pkgs, config, ... }:

{
  home.file.".local/bin/launch-steam" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Launch script for Steam with proper Wayland/XWayland configuration

      echo "Starting Steam with optimized settings..."

      # Check if xwayland-satellite is running
      if ! pgrep -x "xwayland-satellite" > /dev/null; then
          echo "Warning: xwayland-satellite is not running. Starting it..."
          ${pkgs.xwayland-satellite}/bin/xwayland-satellite &
          sleep 2
      fi

      # Set DISPLAY for XWayland if not already set
      if [ -z "$DISPLAY" ]; then
          export DISPLAY=:0
      fi

      echo "Using DISPLAY=$DISPLAY"

      # Launch Steam based on installation type
      if command -v steam > /dev/null 2>&1; then
          # Native Steam installation
          echo "Launching native Steam..."
          exec steam "$@"
      elif flatpak list | grep -q com.valvesoftware.Steam; then
          # Flatpak Steam
          echo "Launching Flatpak Steam..."
          exec flatpak run com.valvesoftware.Steam "$@"
      else
          echo "Error: Steam is not installed!"
          echo "Install Steam via either:"
          echo "  - NixOS: Add 'programs.steam.enable = true;' to your configuration"
          echo "  - Flatpak: flatpak install flathub com.valvesoftware.Steam"
          exit 1
      fi
    '';
  };
}