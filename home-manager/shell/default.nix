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
      ./homebrew.nix
      ./ssh.nix
      ./tools
      ./extras
    ]
    ++ lib.optionals isDesktopEnv [
      ./scripts
    ];
}
