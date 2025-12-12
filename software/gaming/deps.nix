{ pkgs, config, ... }:

{
  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [
    wine
    winetricks
    vkd3d-proton
    config.boot.kernelPackages.xpadneo

    protonplus
    protonup-qt
    protontricks
    gamescope
  ];
}
