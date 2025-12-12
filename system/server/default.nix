{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ./deployment.nix
    ./monitoring.nix
    ./nas-shares.nix
    ./virtualization.nix
    ./secrets.nix
  ];
}
