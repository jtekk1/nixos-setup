{ pkgs, config, osConfig ? null, ... }:

{
  imports = [
    ./settings.nix
    ./style.nix
    ./mango-menu.nix
    ./toggle-waybar.nix
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = false;  # Waybar started manually via toggle-waybar or autostart
  };
}
