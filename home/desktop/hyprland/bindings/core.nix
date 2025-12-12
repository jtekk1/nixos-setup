{ pkgs, config, ... }:

let
  mod = "SUPER";
  app = "uwsm app --";
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Lock screen
      "${mod}, L, exec, ${app} hyprlock"

      # Power menu
      "${mod}, ESCAPE, exec, ~/.local/bin/wofi-power-menu"

      # Notifications
      "SUPER, COMMA, exec, makoctl dismiss"
      "SUPER SHIFT, COMMA, exec, makoctl dismiss --all"
      "SUPER CTRL, COMMA, exec, makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send \"Silenced notifications\" || notify-send \"Enabled notifications\""

      # Toggle features
      "SUPER CTRL, N, exec, toggle-nightlight"

      # Color picker
      "SUPER, PRINT, exec, pkill hyprpicker || hyprpicker -a"
    ];
  };
}
