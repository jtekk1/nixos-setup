{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.jtekk.desktop-env;
  isDesktop = cfg != "server";
in
{
  imports = [ inputs.mangowc.nixosModules.mango ];

  config = lib.mkIf isDesktop {
    programs.mango.enable = true;

    environment.systemPackages = with pkgs;
      [ inputs.mangowc.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    # Required for portals and wlroots renderer to work properly
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "wlroots";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
