{ pkgs, ... }:

{
  hardware.xpadneo.enable = true;
  environment.systemPackages = with pkgs; [
   # Gaming Overlays
    mangohud
    vkbasalt
  ];
}
