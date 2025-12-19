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
  };
}
