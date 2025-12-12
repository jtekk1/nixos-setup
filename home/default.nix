{ pkgs, lib, osConfig, inputs, theme ? "neuro-fusion", ... }:

let
  isDesktop = osConfig.jtekk.desktop-env != "server";
in
{
  imports =
    [
      ./user.nix
      ./shell
      ./theme.nix
    ]
    ++ lib.optionals isDesktop [
      ./apps
      ./desktop/cosmic.nix
      ./desktop/hyprland.nix
      ./desktop/mango.nix
    ];
}
