{ pkgs, inputs, theme ? "neuro-fusion", ... }:

{
  imports = [
    ./common
    ./common/wl-utils
    ./mango
  ];

  # Enable swaybg wallpaper management for mango
  programs.wallpaper.enable = true;
  programs.wallpaper.autoRotate.enable = false;

  # Additional Mango-specific packages
  home.packages = with pkgs; [
    sway-audio-idle-inhibit
  ];
}
