{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    # Noto fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

    # Nerd fonts (programming fonts with icons)
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.zed-mono
    nerd-fonts.roboto-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.daddy-time-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono

    # Icon fonts
    font-awesome
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Jetbrains Mono" ];
      sansSerif = [ "CaskaydiaCove Nerd Font" ];
      monospace = [ "CaskaydiaCove Nerd Font Mono" ];
    };
  };
}
