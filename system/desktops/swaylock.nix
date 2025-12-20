{ lib, config, ... }:

let
  isDesktop = config.jtekk.desktop-env != "server";
in
{
  config = lib.mkIf isDesktop {
    # Enable PAM for swaylock authentication
    security.pam.services.swaylock = {};
  };
}
