{ pkgs, config, lib, osConfig ? null, ... }:

let
  # Disabled - Hyprland removed, using swaylock instead
  enabled = false;

  colors = config.theme.colors;
  # Use rgba format for hyprlock
  color = colors.rgba.fg_secondary 1.0;
  inner_color = colors.rgba.bg_primary 0.8;
  outer_color = colors.rgba.accent_primary 1.0;
  font_color = colors.rgba.fg_secondary 1.0;
  placeholder_color = colors.rgba.fg_secondary 0.6;
  check_color = colors.rgba.accent_secondary 1.0;

  # Wrapper script that always uses --immediate-render (fixes gray screen on mango)
  hyprlock-safe = pkgs.writeShellScriptBin "hyprlock-safe" ''
    exec ${pkgs.hyprlock}/bin/hyprlock --immediate-render "$@"
  '';

in {
  config = lib.mkIf enabled {
    # Add wrapper to PATH
    home.packages = [ hyprlock-safe ];

  # Copy backgrounds to Pictures directory
  home.file = {
    "Pictures/backgrounds/1.png".source = ../../../assets/backgrounds/1.png;
    "Pictures/backgrounds/2.png".source = ../../../assets/backgrounds/2.png;
    "Pictures/backgrounds/3.png".source = ../../../assets/backgrounds/3.png;
  } // lib.optionalAttrs (config.theme.name == "icy-blue") {
    "Pictures/backgrounds/6-draggo.png".source = ../../../assets/backgrounds/6-draggo.png;
    "Pictures/backgrounds/7-draggo.png".source = ../../../assets/backgrounds/7-draggo.png;
    "Pictures/backgrounds/8-draggo.png".source = ../../../assets/backgrounds/8-draggo.png;
  };

  programs.hyprlock = {
    enable = true;
    settings = {

      general = {
        hide_cursor = true;
        screencopy_mode = 1;  # Use CPU buffer instead of DMA (may help with mango)
      };

      background = {
        # Use a symlink that unified-wallpaper will keep updated
        path = "${config.home.homeDirectory}/.config/hyprlock/current-wallpaper";
        color = color;
        blur_passes = 2;
        vibrancy = 0.9;
        vibrancy_darkness = 0.3;
      };

      # Animations (0.9+ syntax)
      animations = {
        enabled = true;
        bezier = "easeOutQuint, 0.22, 1, 0.36, 1";
        animation = [
          "fadeIn, 1, 3, easeOutQuint"
          "fadeOut, 1, 3, easeOutQuint"
          "inputFieldDots, 1, 2, easeOutQuint"
        ];
      };

      label = {
        text = ''$TIME'';
        halign = "center";
        valign = "center";
        position = "0, 200";

        font_family = "CaskaydiaMono Nerd Font";
        font_size = 40;
        color = font_color;

        shadow_passes = 3;
        shadow_size = 3;
        shadow_color = color;
        shadow_boost = 1.2;
      };

      input-field = [
        {
          monitor = "";
          size = "600, 100";
          position = "0, 0";
          halign = "center";
          valign = "center";

          font_color = color;
          inner_color = inner_color;
          outer_color = outer_color;
          outline_thickness = 2;

          placeholder_text = "  Enter Password 󰈷 ";
          check_color = check_color;
          fail_text = ''<i>$PAMFAIL ($ATTEMPTS)</i>'';

          rounding = 5;
          shadow_passes = 1;
          fade_on_empty = false;
        }
      ];

      auth = {
        fingerprint = {
          enabled = true;
        };
      };
    };
  };
  };
}