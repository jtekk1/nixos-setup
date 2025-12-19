{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./xdg.nix
    ./mango.nix
    ./deployment.nix
    ../greeters
  ];
}
