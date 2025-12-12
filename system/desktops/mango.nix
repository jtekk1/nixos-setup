{ pkgs, inputs, ... }:

{
  imports = [ inputs.mangowc.nixosModules.mango ];

  programs.mango.enable = true;

  environment.systemPackages = with pkgs;
    [ inputs.mangowc.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
