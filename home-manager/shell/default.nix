{ pkgs, lib, osConfig ? null, isDesktop ? true, ... }:

let
  isDesktopEnv = if osConfig != null
    then osConfig.jtekk.desktop-env != "server"
    else isDesktop;
in
{
  imports =
    [
      ./bash
      ./ssh.nix
      ./tools
    ]
    ++ lib.optionals isDesktopEnv [
      ./scripts
    ];
}
