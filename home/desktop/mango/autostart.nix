{ pkgs, inputs, ... }:

let cutacha = inputs.cutacha.packages.${pkgs.system}.default;

in {
  wayland.windowManager.mango.autostart_sh = ''
    # Autostart script for Mango WM (no shebang needed)
    set +e

    # Set desktop environment for blueberry and other apps
    export XDG_CURRENT_DESKTOP=wlroots
    export XDG_SESSION_TYPE=wayland
    export WAYLAND_DISPLAY="''${WAYLAND_DISPLAY:-wayland-0}"

    # OBS desktop portal
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

    # Notification daemon (use mako which is simpler)
    ${pkgs.mako}/bin/mako >/dev/null 2>&1 &

    # Night light filter
    ${pkgs.wlsunset}/bin/wlsunset -T 4501 -t 4500 >/dev/null 2>&1 &

    # Wallpaper daemon and restore handled by systemd services:
    # - swww-daemon.service (starts daemon)
    # - wallpaper-restore.service (restores current wallpaper)
    # Both are triggered by graphical-session.target below

    # Cutacha status bar
    ${cutacha}/bin/cutacha >/dev/null 2>&1 &

    # Status bar disabled
    # # Suppress fontconfig warnings by setting debug level to 0
    # export FONTCONFIG_FILE=/etc/fonts/fonts.conf
    # export FONTCONFIG_PATH=/etc/fonts
    # export FC_DEBUG=0
    # ${pkgs.waybar}/bin/waybar >/dev/null 2>&1 &

    # # Wait for waybar tray to initialize before starting tray apps
    # while ! pgrep -x waybar >/dev/null 2>&1; do sleep 0.1; done
    # sleep 0.3  # Brief additional wait for tray to be ready

    # XWayland DPI scaling
    echo "Xft.dpi: 120" | ${pkgs.xorg.xrdb}/bin/xrdb -merge >/dev/null 2>&1

    # Keep clipboard content
    ${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

    # Clipboard content manager
    ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store >/dev/null 2>&1 &
    ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store >/dev/null 2>&1 &

    # Network manager applet
    # ${pkgs.networkmanagerapplet}/bin/nm-applet >/dev/null 2>&1 &

    # Authentication agent
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &

    # sway-audio-idle-inhibit is now managed by systemd (see idle-inhibit.nix)

    # OSD service for volume and brightness
    ${pkgs.swayosd}/bin/swayosd-server >/dev/null 2>&1 &

    # Start user graphical session target
    systemctl --user start graphical-session.target >/dev/null 2>&1

    echo "Mango WM autostart completed"
  '';
}
