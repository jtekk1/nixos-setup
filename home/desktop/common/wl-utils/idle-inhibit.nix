{ pkgs, config, ... }:

{
  # Environment variables to enable idle inhibit for various applications
  home.sessionVariables = {
    # Firefox/Chromium should inhibit idle during video playback
    MOZ_USE_WAYLAND_IDLE_INHIBITOR = "1";

    # MPV configuration for idle inhibit
    MPV_IDLE_INHIBIT = "yes";
  };

  # MPV configuration for idle inhibit during video playback
  xdg.configFile."mpv/mpv.conf" = {
    enable = true;
    text = ''
      # Idle inhibit settings
      stop-screensaver=yes

      # Video output settings for Wayland
      vo=dmabuf-wayland,wlshm,gpu
      hwdec=auto-safe

      # Keep screen on during playback
      idle=yes
    '';
  };

  # Configure VLC for idle inhibit
  xdg.configFile."vlc/vlcrc" = {
    enable = true;
    text = ''
      # Inhibit idle/screensaver during playback
      [core]
      inhibit=1

      # Use Wayland output
      [vout]
      vout=wayland
    '';
  };

  # Systemd service for sway-audio-idle-inhibit (more reliable than autostart)
  systemd.user.services.sway-audio-idle-inhibit = {
    Unit = {
      Description = "Idle inhibitor when audio is playing";
      After = [ "graphical-session.target" "pipewire.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Install tools for manual control if needed
  home.packages = with pkgs; [
    sway-audio-idle-inhibit
    # Tool to manually inhibit idle (useful for games, presentations, etc.)
    # Usage: idle-inhibit-toggle
    (writeShellScriptBin "idle-inhibit-toggle" ''
      #!/usr/bin/env bash
      # Toggle idle inhibit manually

      INHIBIT_FILE="/tmp/idle-inhibit-$$"

      if [ -f "$INHIBIT_FILE" ]; then
        rm "$INHIBIT_FILE"
        notify-send "Idle Inhibit" "Disabled - System will auto-lock" -t 2000
        pkill -f "systemd-inhibit --what=idle"
      else
        touch "$INHIBIT_FILE"
        notify-send "Idle Inhibit" "Enabled - System won't auto-lock" -t 2000
        systemd-inhibit --what=idle --who="user" --why="Manual idle inhibit" --mode=block sleep infinity &
      fi
    '')
  ];

  # Create a desktop entry for the idle inhibit toggle
  xdg.desktopEntries.idle-inhibit-toggle = {
    name = "Toggle Idle Inhibit";
    genericName = "Idle Control";
    exec = "idle-inhibit-toggle";
    terminal = false;
    categories = [ "Utility" "System" ];
    icon = "system-lock-screen";
    comment = "Toggle system idle inhibitor";
  };
}