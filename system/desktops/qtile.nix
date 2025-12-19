{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.jtekk.desktop-env;
  isQtile = cfg != "mango-hypr";
  qtileFullPkg =
    inputs.qtile.packages.${pkgs.stdenv.hostPlatform.system}.qtile-full;
in {
  config = lib.mkIf isQtile {
    # Qtile Wayland compositor
    services.xserver.windowManager.qtile = {
      enable = true;
      package = qtileFullPkg;
      backend = "wayland";
      extraPackages = python3Packages:
        with python3Packages; [
          qtile-extras
          dbus-python
          psutil
        ];
    };

    # Create Wayland session entry for greetd/regreet
    services.xserver.displayManager.sessionPackages = [
      (pkgs.runCommand "qtile-wayland-session" { } ''
        mkdir -p $out/share/wayland-sessions
        cat > $out/share/wayland-sessions/qtile-wayland.desktop <<EOF
        [Desktop Entry]
        Name=QTile Wayland
        Comment=Qtile tiling window manager on Wayland
        Exec=${qtileFullPkg}/bin/qtile start -b wayland
        Type=Application
        DesktopNames=Qtile
        EOF
      '')
    ];

    # Qtile/Wayland ecosystem packages
    environment.systemPackages = with pkgs; [
      # Lock screen and idle
      swaylock-effects
      swayidle

      # Qtile utilities
      python3Packages.qtile-extras
    ];

    # PAM configuration for swaylock
    security.pam.services.swaylock = { };
  };
}
