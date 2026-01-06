{ pkgs, lib, ... }:

{
  home.sessionVariables = {
    # Default applications
    TERMINAL = "foot";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "chromium";

    # Wayland support
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "wlroots";
    XDG_SESSION_TYPE = "wayland";
  };
}
