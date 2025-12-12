{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
  security.polkit.enable = true;
  services.flatpak.enable = true;

  # Enable dconf for GTK/GNOME application settings
  programs.dconf.enable = true;
}
