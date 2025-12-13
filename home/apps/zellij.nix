# Zellij terminal multiplexer configuration with theme support
{ config, pkgs, lib, ... }:

let
  colors = config.theme.colors;
  themeName = config.theme.name;
in
{
  programs.zellij = {
    enable = true;
    settings = {
      theme = themeName;
      themes.${themeName} = {
        fg = colors.fg_primary;
        bg = colors.bg_primary;
        black = colors.color0;
        red = colors.color1;
        green = colors.color2;
        yellow = colors.color3;
        blue = colors.color4;
        magenta = colors.color5;
        cyan = colors.color6;
        white = colors.color7;
        orange = colors.accent_tertiary;
      };
      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };
    };
  };
}
