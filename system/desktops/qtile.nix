{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.jtekk.desktop-env;
  isQtile = cfg != "mango-hypr";
  qtilePkg =
    inputs.qtile.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Override qtile-extras to skip flaky tests
  qtile-extras-nocheck = pkgs.python3Packages.qtile-extras.overrideAttrs (old: {
    doCheck = false;
  });
in {
  config = lib.mkIf isQtile {
    # Qtile compositor (provides both X11 and Wayland sessions automatically)
    services.xserver.windowManager.qtile = {
      enable = true;
      package = qtilePkg;
      extraPackages = python3Packages:
        with python3Packages; [
          dbus-python
          psutil
        ] ++ [ qtile-extras-nocheck ];
    };

    # Qtile/Wayland ecosystem packages
    environment.systemPackages = with pkgs; [
      # Lock screen and idle
      swaylock-effects
      swayidle
    ] ++ [ qtile-extras-nocheck ];

    # PAM configuration for swaylock
    security.pam.services.swaylock = { };
  };
}
