{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "cmd-close-all-windows" ''
      # Close all open windows
      ${hyprland}/bin/hyprctl clients -j |
        ${jq}/bin/jq -r ".[].address" |
        ${findutils}/bin/xargs -I{} ${hyprland}/bin/hyprctl dispatch closewindow address:{}

      # Move to first workspace
      ${hyprland}/bin/hyprctl dispatch workspace 1
    '')
  ];
}
