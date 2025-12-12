{ pkgs, lib, config, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains-toolbox
    zed-editor
    # code-cursor removed - using Cursor AppImage v2.0.34 instead (much newer than nixpkgs v1.7.52)
  ];
}
