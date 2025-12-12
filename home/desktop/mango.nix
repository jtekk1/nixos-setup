{ pkgs, inputs, theme ? "neuro-fusion", ... }:

{
  imports = [
    ./common
    ./common/wl-utils
    ./mango
  ];

  # Additional Mango-specific packages
  home.packages = with pkgs; [
    sway-audio-idle-inhibit
  ];
}
