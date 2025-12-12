{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlsunset  # Blue light filter
  ];
}
