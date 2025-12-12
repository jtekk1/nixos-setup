{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./common
  ];

  # COSMIC manages its own GTK theming - disable home-manager GTK4 management
  # to avoid conflicts with COSMIC-generated gtk.css
  gtk.gtk4.extraCss = lib.mkForce "";
  xdg.configFile."gtk-4.0/gtk.css".enable = lib.mkForce false;

  home.packages = with pkgs; [
    # COSMIC extensions and apps (not provided by NixOS module)
    cosmic-ext-ctl
    cosmic-ext-tweaks
    cosmic-ext-calculator
    quick-webapps
    examine
    tasks
    oboete
  ];
}
