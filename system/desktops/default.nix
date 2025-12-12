{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./xdg.nix
    ./cosmic.nix
    ./hyprland.nix
    ./mango.nix
    ./deployment.nix
  ];
}
