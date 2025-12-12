{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./fonts.nix
    ./networking.nix
    ./services.nix
    ./system.nix
    ./tailscale.nix
    ./users.nix
  ];
}
