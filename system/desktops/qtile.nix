{ pkgs, lib, config, ... }:

let
  cfg = config.jtekk.desktop-env;
  isQtile = cfg != "mango-hypr";
in {
  config = lib.mkIf isQtile {
    # Qtile compositor (uses nixpkgs qtile with our overlay)
    services.xserver.windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages:
        with python3Packages; [
          qtile-extras
          dbus-python
          psutil
        ];
    };

    # Qtile/Wayland ecosystem packages
    environment.systemPackages = with pkgs; [
      # Lock screen and idle
      swaylock-effects
      swayidle
      python3Packages.qtile-extras
    ];

    # PAM configuration for swaylock
    security.pam.services.swaylock = { };
  };
}
