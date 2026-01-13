{ pkgs, inputs, ... }:

{
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

    # Waybar status bar
    ${pkgs.waybar}/bin/waybar >/dev/null 2>&1 &

    # XWayland DPI scaling
    echo "Xft.dpi: 120" | ${pkgs.xorg.xrdb}/bin/xrdb -merge >/dev/null 2>&1

    # Keep clipboard content
    ${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

    # Clipboard content manager
    ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store >/dev/null 2>&1 &
    ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store >/dev/null 2>&1 &

    # Authentication agent
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &

    # OSD service for volume and brightness
    ${pkgs.swayosd}/bin/swayosd-server >/dev/null 2>&1 &

    # Disable projector on startup (can be enabled via keybind or cutacha)
    # mmsg -d "disable_monitor,HDMI-A-2" >/dev/null 2>&1

    # Start user graphical session target
    systemctl --user start graphical-session.target >/dev/null 2>&1
  '';
}
