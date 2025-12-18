{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Scratchpad
    bind=SUPER,minus,toggle_scratchpad

    # Screenshots
    bind=,Print,spawn,grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
    bind=CTRL+ALT,4,spawn,grim - | wl-copy
    bind=CTRL+SHIFT,4,spawn,~/.local/bin/screenshot-area --clipboard
    bind=CTRL+ALT,a,spawn_shell,grim -g "$(slurp -b '#2E2A1E55' -c '#88c0d0ff')" -t ppm - | satty -f -

    # Wofi launchers and menus
    bind=SUPER,space,spawn,wofi --show drun
    bind=SUPER,r,spawn,wofi --show run
    bind=SUPER,v,spawn,~/.local/bin/wofi-clipboard-menu

    # Lock screen
    bind=SUPER+CTRL,Escape,spawn,hyprlock-safe

    # Notification center
    bind=SUPER,backspace,spawn,swaync-client -t
    bind=SUPER+SHIFT,backspace,spawn,swaync-client -C

    # Waybar toggle
    bind=SUPER+SHIFT,b,spawn,killall -SIGUSR1 waybar

    # Power menu
    bind=SUPER,Escape,spawn,~/.local/bin/wofi-power-menu

    # Mouse bindings
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize
    mousebind=SUPER,btn_middle,togglefloating

    # Scroll bindings
    axisbind=SUPER,up,cyclelayout
  '';
}
