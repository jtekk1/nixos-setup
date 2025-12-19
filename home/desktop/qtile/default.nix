{ config, pkgs, ... }:

let
  colors = config.theme.colors;

  # Generate colors.py from theme
  colorsPy = pkgs.writeText "colors.py" ''
    # Auto-generated from NixOS theme: ${config.theme.name}
    # Do not edit - changes will be overwritten on rebuild

    colors = {
        "bg_primary": "${colors.bg_primary}",
        "bg_secondary": "${colors.bg_secondary}",
        "bg_tertiary": "${colors.bg_tertiary}",
        "fg_primary": "${colors.fg_primary}",
        "fg_secondary": "${colors.fg_secondary}",
        "fg_dim": "${colors.fg_dim}",
        "accent_primary": "${colors.accent_primary}",
        "accent_secondary": "${colors.accent_secondary}",
        "accent_tertiary": "${colors.accent_tertiary}",
        "border_active": "${colors.border_active_1}",
        "border_inactive": "${colors.border_inactive}",
        "color0": "${colors.color0}",
        "color1": "${colors.color1}",
        "color2": "${colors.color2}",
        "color3": "${colors.color3}",
        "color4": "${colors.color4}",
        "color5": "${colors.color5}",
        "color6": "${colors.color6}",
        "color7": "${colors.color7}",
        "color8": "${colors.color8}",
        "color9": "${colors.color9}",
        "color10": "${colors.color10}",
        "color11": "${colors.color11}",
        "color12": "${colors.color12}",
        "color13": "${colors.color13}",
        "color14": "${colors.color14}",
        "color15": "${colors.color15}",
    }
  '';

in {
  # Symlink Python config directory to ~/.config/qtile
  xdg.configFile."qtile" = {
    source = ./config;
    recursive = true;
  };

  # Generated colors from theme
  xdg.configFile."qtile/colors.py".source = colorsPy;
}
