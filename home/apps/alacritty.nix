# Alacritty terminal configuration with theme support
{ config, pkgs, ... }:

let colors = config.theme.colors;
in {
  programs.alacritty = {
    enable = true;

    settings = {
      # Window settings
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        opacity = 0.95;
        decorations = "full";
      };

      # Font settings
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 11.0;
      };

      # Scrollback
      scrolling = {
        history = 10000;
      };

      # Cursor
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        blink_interval = 500;
      };

      # Theme colors
      colors = {
        primary = {
          foreground = colors.fg_primary;
          background = colors.bg_primary;
        };

        selection = {
          text = colors.selection_fg;
          background = colors.selection_bg;
        };

        cursor = {
          text = colors.bg_primary;
          cursor = colors.cursor;
        };

        # Normal colors (0-7)
        normal = {
          black = colors.color0;
          red = colors.color1;
          green = colors.color2;
          yellow = colors.color3;
          blue = colors.color4;
          magenta = colors.color5;
          cyan = colors.color6;
          white = colors.color7;
        };

        # Bright colors (8-15)
        bright = {
          black = colors.color8;
          red = colors.color9;
          green = colors.color10;
          yellow = colors.color11;
          blue = colors.color12;
          magenta = colors.color13;
          cyan = colors.color14;
          white = colors.color15;
        };
      };

      # Hints for URLs
      hints = {
        enabled = [{
          regex = "(https?://)[a-zA-Z0-9._-]+\\.[a-zA-Z]{2,}[/a-zA-Z0-9._~:/?#\\[\\]@!$&'()*+,;=-]*";
          hyperlinks = true;
          command = "xdg-open";
          post_processing = true;
          mouse = {
            enabled = true;
            mods = "Control";
          };
        }];
      };
    };
  };
}
