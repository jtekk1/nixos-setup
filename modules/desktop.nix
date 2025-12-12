{ lib, ... }:

{
  options.jtekk.desktop-env = lib.mkOption {
    type = lib.types.str;
    default = "none";
    description = "Active desktop environment (server, desktop, mango, hyprland, cosmic, cosmic-mango)";
  };
}
