# Foot terminal configuration with theme support
{ config, pkgs, ... }:

let
  colors = config.theme.colors;
  # Strip # from hex colors for foot's format
  strip = color: builtins.substring 1 6 color;
in {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        pad = "10x10";
        term = "xterm-256color";
      };

      scrollback = { lines = 10000; };

      cursor = {
        style = "beam";
        blink = "yes";
      };

      colors = {
        foreground = strip colors.fg_primary;
        background = strip colors.bg_primary;
        selection-foreground = strip colors.selection_fg;
        selection-background = strip colors.selection_bg;

        # Terminal color palette (0-15)
        regular0 = strip colors.color0;
        regular1 = strip colors.color1;
        regular2 = strip colors.color2;
        regular3 = strip colors.color3;
        regular4 = strip colors.color4;
        regular5 = strip colors.color5;
        regular6 = strip colors.color6;
        regular7 = strip colors.color7;

        bright0 = strip colors.color8;
        bright1 = strip colors.color9;
        bright2 = strip colors.color10;
        bright3 = strip colors.color11;
        bright4 = strip colors.color12;
        bright5 = strip colors.color13;
        bright6 = strip colors.color14;
        bright7 = strip colors.color15;

        urls = strip colors.url;
      };
    };
  };
}
