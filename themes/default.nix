# Theme system main entry point
{ lib, theme ? "neuro-fusion" }:

let
  # Import color conversion utilities
  utils = import ./lib/utils.nix { inherit lib; };

  # Load the appropriate theme colors
  colors = import ./${theme}.nix;

  # Helper function to convert colors to different formats
  mkThemeColors = colors: {
    # Original colors
    inherit (colors)
      bg_primary bg_secondary bg_tertiary
      fg_primary fg_secondary fg_dim
      accent_primary accent_secondary accent_tertiary
      cursor selection_bg selection_fg url
      border_active_1 border_active_2 border_inactive
      color0 color1 color2 color3 color4 color5 color6 color7
      color8 color9 color10 color11 color12 color13 color14 color15
      wallpapers;

    # Additional format conversions using utils
    rgba = {
      bg_primary = alpha: utils.hexToRgba colors.bg_primary alpha;
      bg_secondary = alpha: utils.hexToRgba colors.bg_secondary alpha;
      fg_primary = alpha: utils.hexToRgba colors.fg_primary alpha;
      fg_secondary = alpha: utils.hexToRgba colors.fg_secondary alpha;
      accent_primary = alpha: utils.hexToRgba colors.accent_primary alpha;
      accent_secondary = alpha: utils.hexToRgba colors.accent_secondary alpha;
      border_active_1 = alpha: utils.hexToRgba colors.border_active_1 alpha;
      border_active_2 = alpha: utils.hexToRgba colors.border_active_2 alpha;
    };

    # 0xRRGGBBaa format for Mango WM
    mango = {
      bg_primary = alpha: utils.hexTo0xFormat colors.bg_primary alpha;
      fg_primary = alpha: utils.hexTo0xFormat colors.fg_primary alpha;
      accent_primary = alpha: utils.hexTo0xFormat colors.accent_primary alpha;
      border_active_1 = alpha: utils.hexTo0xFormat colors.border_active_1 alpha;
      border_active_2 = alpha: utils.hexTo0xFormat colors.border_active_2 alpha;
    };

    # Check if we have Mango-specific overrides
    mangoOverrides = colors.mango_overrides or null;

    # Check if we have gray scale
    grayScale = colors.gray_scale or null;
  };
in
  mkThemeColors colors