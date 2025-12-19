{ ... }:

{
  # Desktop software - imported via baseModules for mkSystem only
  imports = [
    ./unfree.nix
    ./apps.nix
    ./appimages
    ./gaming
    ./packages
    ./programming

    # Optional software (guarded by lib.mkIf)
    ./optional/teamviewer.nix
    ./optional/openrgb.nix
  ];
}
