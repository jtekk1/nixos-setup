{ pkgs, lib, osConfig ? null, inputs, theme ? "neuro-fusion", isDesktop ? true, ... }:

let
  # Use osConfig if available (NixOS module), otherwise use passed isDesktop arg (standalone)
  isDesktopEnv = if osConfig != null
    then osConfig.jtekk.desktop-env != "server"
    else isDesktop;

  # Check if we're in mango-hypr mode
  isMangoHypr = osConfig != null && osConfig.jtekk.desktop-env == "mango-hypr";
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
    ]
    # Qtile for default desktop
    ++ lib.optionals (isDesktopEnv && !isMangoHypr) [
      ./desktop/qtile.nix
    ]
    # Mango + Hyprland for mango-hypr specialisation
    ++ lib.optionals (isDesktopEnv && isMangoHypr) [
      ./desktop/hyprland.nix
      ./desktop/mango.nix
    ];
}
