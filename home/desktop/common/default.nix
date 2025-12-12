{ pkgs, ... }:

{
  imports = [
    ./session-vars.nix
    ./theme.nix
    ./xdg.nix
  ];
}
