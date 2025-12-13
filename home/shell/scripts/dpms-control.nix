{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "dpms-off" ''
      # Turn off displays based on current desktop environment
      case "$XDG_CURRENT_DESKTOP" in
        Hyprland)
          ${hyprland}/bin/hyprctl dispatch dpms off
          ;;
        mango|*)
          ${wlopm}/bin/wlopm --off '*'
          ;;
      esac
    '')

    (writeShellScriptBin "dpms-on" ''
      # Turn on displays based on current desktop environment
      case "$XDG_CURRENT_DESKTOP" in
        Hyprland)
          ${hyprland}/bin/hyprctl dispatch dpms on
          ;;
        mango|*)
          ${wlopm}/bin/wlopm --on '*'
          ;;
      esac
    '')
  ];
}
