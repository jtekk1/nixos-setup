{ pkgs, lib, osConfig ? null, inputs, theme ? "neuro-fusion", isDesktop ? true, ... }:

let
  # Use osConfig if available (NixOS module), otherwise use passed isDesktop arg (standalone)
  isDesktopEnv = if osConfig != null
    then osConfig.jtekk.desktop-env != "server"
    else isDesktop;
in
{
  imports =
    [
      ./user.nix
      ./shell
      ./theme.nix
    ]
    ++ lib.optionals isDesktopEnv [
      ./apps
      ./desktop/cosmic.nix
      ./desktop/hyprland.nix
      ./desktop/mango.nix
    ];
}
