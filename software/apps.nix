{ config, lib, pkgs, inputs, ... }:

{
  # Enable v4l2loopback for OBS virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
  '';

  # Enable Chromium with Widevine support for streaming services
  programs.chromium.enable = true;

  environment.systemPackages = with pkgs; [
    # Chromium with Wayland support and Widevine for streaming
    # Note: KDE uses XWayland (NIXOS_OZONE_WL disabled) due to native Wayland crash
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
        "--ozone-platform-hint=auto" # Use auto instead of forcing wayland
        "--enable-wayland-ime"
        "--gtk-version=4"
        "--enable-zero-copy"
      ];
    })

    # Image editing
    gimp
    inkscape
    imagemagick
    pinta

    spotify
    obsidian
    typora
    shotcut # Video editor
    bitwarden-desktop # Password manager (works with Vaultwarden)
    slack
    zoom-us

    # Discord wrapper for proper Wayland support
    (writeShellScriptBin "discord" ''
      # Ensure Wayland display is set
      export WAYLAND_DISPLAY=''${WAYLAND_DISPLAY:-wayland-1}
      export XDG_SESSION_TYPE=''${XDG_SESSION_TYPE:-wayland}
      export NIXOS_OZONE_WL=1

      # Launch Discord with proper environment
      exec ${discord}/bin/discord "$@"
    '')

    # OBS Studio with proper Wayland and plugin support
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vaapi
        obs-vkcapture
      ];
    })

    # Media viewers (shared across desktops)
    imv # Image viewer
    zathura # PDF viewer
    mpv # Media player

    # File manager and app store
    nautilus
    bazaar

    # Desktop utilities
    nwg-look # GTK theme settings
    # gemini-cli # AI CLI tool - temporarily disabled due to npm deps hash mismatch
    wl-screenrec # Wayland screen recorder

    # Home-manager CLI for standalone usage
    inputs.home-manager.packages.${pkgs.system}.home-manager
  ];
}
