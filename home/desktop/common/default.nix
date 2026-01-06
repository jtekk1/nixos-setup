{ pkgs, ... }:

{
  imports = [
    ./session-vars.nix
    ./theme.nix
    ./wallpaper.nix
    ./xdg.nix
  ];
}
