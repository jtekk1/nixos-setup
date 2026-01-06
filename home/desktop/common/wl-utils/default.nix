{ pkgs, ... }:

{
  imports = [
    ./clipboard.nix
    ./kanshi.nix
    ./swayidle.nix
    ./swaylock.nix
    ./idle-inhibit.nix
    ./mako.nix
    ./screenshot.nix
    ./swayosd.nix
    ./uwsm.nix
    ./wallpaper.nix
    ./wlsunset.nix
    ./status-weather.nix
    ./wofi.nix
  ];

  home.packages = with pkgs; [
    wayland-utils
    wev
  ];
}
