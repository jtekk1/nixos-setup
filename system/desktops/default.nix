{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./xdg.nix
    ./mango.nix
    ./swaylock.nix
    ./deployment.nix
    ../greeters
  ];
}
