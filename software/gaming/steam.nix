{ lib, pkgs, ... }:

{
  imports = [
    ../unfree.nix
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    steam-tui
  ];
}
