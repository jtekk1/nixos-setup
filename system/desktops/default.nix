{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./xdg.nix
    ./qtile.nix
    ./hyprland.nix
    ./mango.nix
    ./deployment.nix
    ../greeters
  ];
}
