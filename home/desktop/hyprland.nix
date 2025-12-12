{ config, lib, pkgs, inputs, theme ? "neuro-fusion", ... }:

{
  imports = [
    ./common
    ./common/wl-utils
    ./hyprland
  ];
}
