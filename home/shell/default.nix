{ pkgs, lib, osConfig, ... }:

let
  isDesktop = osConfig.jtekk.desktop-env != "server";
in
{
  imports =
    [
      ./bash
      ./ssh.nix
      ./tools
    ]
    ++ lib.optionals isDesktop [
      ./scripts
    ];
}
