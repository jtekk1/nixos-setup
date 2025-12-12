# Kitty terminal configuration with theme support
{ config, pkgs, ... }:

let colors = config.theme.colors;
in {
  programs.kitty = {
    enable = true;

    # Font settings from your Alacritty config
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11.0;
    };

    # General settings merged from your examples
    settings = {
      # Window & Behavior (non-color settings remain unchanged)
      background_opacity = "0.95";
      inactive_text_alpha = "0.85";
      window_padding_width = 10;
      scrollback_lines = 10000;
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 500;

      # Theme colors
      foreground = colors.fg_primary;
      background = colors.bg_primary;
      selection_foreground = colors.selection_fg;
      selection_background = colors.selection_bg;

      cursor = colors.cursor;
      cursor_text_color = colors.bg_primary;
      url_color = colors.url;

      # Terminal color palette (0-15)
      inherit (colors)
        color0 color1 color2 color3 color4 color5 color6 color7 color8 color9
        color10 color11 color12 color13 color14 color15;

      # UI Colors (Tabs, Borders etc.)
      active_border_color = colors.accent_primary;
      inactive_border_color = colors.bg_tertiary;
      bell_border_color = colors.accent_tertiary;

      active_tab_foreground = colors.bg_primary;
      active_tab_background = colors.fg_primary;
      inactive_tab_foreground = colors.fg_primary;
      inactive_tab_background = colors.bg_secondary;
      tab_bar_background = colors.bg_primary;
    };

    # For settings without a dedicated Home Manager option (like blur)
    extraConfig = ''
      # The blur effect requires a compositor like picom or a Wayland equivalent
      background_blur 10
    '';
  };
}
