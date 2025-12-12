# Ghostty terminal configuration with theme support
{ config, pkgs, ... }:

let colors = config.theme.colors;
in {
  programs.ghostty = {
    enable = true;

    # Shell integrations
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    settings = {
      # Font settings
      font-family = "JetBrainsMono Nerd Font";
      font-size = 11;

      # Window settings
      window-padding-x = 10;
      window-padding-y = 10;
      background-opacity = 0.95;
      window-decoration = true;

      # Scrollback
      scrollback-limit = 10000;

      # Cursor
      cursor-style = "bar";
      cursor-style-blink = true;

      # Theme colors
      foreground = colors.fg_primary;
      background = colors.bg_primary;
      selection-foreground = colors.selection_fg;
      selection-background = colors.selection_bg;
      cursor-color = colors.cursor;

      # Terminal color palette (0-15)
      palette = [
        "0=${colors.color0}"
        "1=${colors.color1}"
        "2=${colors.color2}"
        "3=${colors.color3}"
        "4=${colors.color4}"
        "5=${colors.color5}"
        "6=${colors.color6}"
        "7=${colors.color7}"
        "8=${colors.color8}"
        "9=${colors.color9}"
        "10=${colors.color10}"
        "11=${colors.color11}"
        "12=${colors.color12}"
        "13=${colors.color13}"
        "14=${colors.color14}"
        "15=${colors.color15}"
      ];

      # Misc
      copy-on-select = "clipboard";
      confirm-close-surface = false;
    };
  };
}
