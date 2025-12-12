{ pkgs, config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Window management
      "SUPER, Q, killactive,"
      "CTRL ALT, DELETE, exec, close-all-windows"
      "SUPER, J, togglesplit,"
      "SUPER, P, pseudo,"
      "SUPER, V, togglefloating,"
      "SHIFT, F11, fullscreen, 0"

      # Move focus
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"

      # Swap active window
      "SUPER SHIFT, left, swapwindow, l"
      "SUPER SHIFT, right, swapwindow, r"
      "SUPER SHIFT, up, swapwindow, u"
      "SUPER SHIFT, down, swapwindow, d"

      # Resize active window
      "SUPER, minus, resizeactive, -100 0"
      "SUPER, equal, resizeactive, 100 0"
      "SUPER SHIFT, minus, resizeactive, 0 -100"
      "SUPER SHIFT, equal, resizeactive, 0 100"
    ];

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  };
}
