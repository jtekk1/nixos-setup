{ lib, config, ... }:

{
  options.jtekk.software = {
    teamviewer.enable = lib.mkEnableOption "TeamViewer";
    openrgb.enable = lib.mkEnableOption "OpenRGB";
    winboat.enable = lib.mkEnableOption "Windows VM";
  };
}
