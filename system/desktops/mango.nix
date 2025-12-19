{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.jtekk.desktop-env;
  isMangoHypr = cfg == "mango-hypr";
in
{
  imports = [ inputs.mangowc.nixosModules.mango ];

  config = lib.mkIf isMangoHypr {
    programs.mango.enable = true;

    environment.systemPackages = with pkgs;
      [ inputs.mangowc.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
