# Theme module - makes theme colors available to all home-manager modules
{ config, lib, pkgs, theme ? "neuro-fusion", ... }:

let themeColors = import ../themes/default.nix { inherit lib theme; };
in {
  # Make theme colors available as config.theme.colors
  options.theme = {
    colors = lib.mkOption {
      type = lib.types.attrs;
      default = themeColors;
      description = "Current theme color definitions";
    };

    name = lib.mkOption {
      type = lib.types.str;
      default = theme;
      description = "Current theme name";
    };
  };

  config = {
    theme.colors = themeColors;
    theme.name = theme;
  };
}

