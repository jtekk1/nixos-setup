{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./core.nix         # Core AppImage configuration and enablement
    ./packages.nix     # AppImage package definitions and selections
  ];
}
