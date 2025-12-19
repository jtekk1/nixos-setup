{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.jtekk.desktop-env;
  isMangoHypr = cfg == "mango-hypr";
in
{
  config = lib.mkIf isMangoHypr {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      withUWSM = true;
    };

    # PAM configuration for hyprlock screen locker
    security.pam.services.hyprlock = {};

    # Hyprland ecosystem packages
    environment.systemPackages = with pkgs; [
      hypridle
      hyprland-qtutils
      hyprlock
      hyprcursor
    ];
  };
}
