{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "dpms-off" ''
      # Turn off displays based on current desktop environment
      case "$XDG_CURRENT_DESKTOP" in
        Hyprland)
          ${hyprland}/bin/hyprctl dispatch dpms off
          ;;
        mango)
          # Use native mmsg IPC for mango
          for output in $(${wlr-randr}/bin/wlr-randr --json | ${jq}/bin/jq -r '.[] | select(.enabled) | .name'); do
            mmsg -d "disable_monitor,$output"
          done
          ;;
        *)
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
        mango)
          # Use native mmsg IPC for mango
          for output in $(${wlr-randr}/bin/wlr-randr --json | ${jq}/bin/jq -r '.[].name'); do
            mmsg -d "enable_monitor,$output"
          done
          ;;
        *)
          ${wlopm}/bin/wlopm --on '*'
          ;;
      esac
    '')
  ];
}
