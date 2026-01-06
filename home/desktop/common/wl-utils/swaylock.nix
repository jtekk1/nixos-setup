{ pkgs, config, lib, osConfig ? null, ... }:

let
  # Enable for desktop environments
  isDesktop = osConfig == null || osConfig.jtekk.desktop-env != "server";

  colors = config.theme.colors;

in {
  config = lib.mkIf isDesktop {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        # Colors from theme
        color = colors.bg_primary;
        inside-color = colors.bg_secondary;
        inside-clear-color = colors.bg_tertiary;
        inside-ver-color = colors.accent_primary;
        inside-wrong-color = colors.color1;

        line-color = colors.bg_primary;
        line-clear-color = colors.bg_primary;
        line-ver-color = colors.bg_primary;
        line-wrong-color = colors.bg_primary;

        ring-color = colors.border_inactive;
        ring-clear-color = colors.accent_secondary;
        ring-ver-color = colors.accent_primary;
        ring-wrong-color = colors.color1;

        key-hl-color = colors.accent_primary;
        bs-hl-color = colors.color1;

        text-color = colors.fg_primary;
        text-clear-color = colors.fg_primary;
        text-ver-color = colors.fg_primary;
        text-wrong-color = colors.fg_primary;

        separator-color = "00000000";

        # Effects
        screenshots = true;
        clock = true;
        indicator = true;
        indicator-radius = 100;
        indicator-thickness = 7;

        effect-blur = "7x5";
        effect-vignette = "0.5:0.5";

        font = "CaskaydiaMono Nerd Font";
        font-size = 24;

        fade-in = 0.2;
        grace = 2;
        grace-no-mouse = true;
        grace-no-touch = true;

        datestr = "%a, %b %d";
        timestr = "%H:%M";
      };
    };
  };
}
