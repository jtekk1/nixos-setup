{ pkgs, config, ... }:

let
  mod = "SUPER";
  ctrlMod = "${mod} CTRL";
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Switch workspaces
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"

      # Move active window to workspace
      "SUPER SHIFT, 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, movetoworkspace, 5"
      "SUPER SHIFT, 6, movetoworkspace, 6"
      "SUPER SHIFT, 7, movetoworkspace, 7"
      "SUPER SHIFT, 8, movetoworkspace, 8"
      "SUPER SHIFT, 9, movetoworkspace, 9"
      "SUPER SHIFT, 0, movetoworkspace, 10"

      # Tab between workspaces
      "SUPER, TAB, workspace, e+1"
      "SUPER SHIFT, TAB, workspace, e-1"

      # Scroll through workspaces
      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"

      # Cycle through applications
      "ALT, Tab, cyclenext"
      "ALT SHIFT, Tab, cyclenext, prev"
      "ALT, Tab, bringactivetotop"
      "ALT SHIFT, Tab, bringactivetotop"

      # Wofi window switcher
      "${ctrlMod}, TAB, exec, ~/.local/bin/wofi-window-switcher"
    ];
  };
}
