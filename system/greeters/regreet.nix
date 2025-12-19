{ pkgs, lib, theme ? "nightfox", ... }:

let
  themeColors = import ../../themes/default.nix { inherit lib theme; };

  regreetCss = ''
    window {
      background-color: ${themeColors.bg_primary};
    }

    box#body {
      background-color: ${themeColors.bg_secondary};
      border-radius: 12px;
      padding: 32px;
    }

    entry {
      background-color: ${themeColors.bg_tertiary};
      color: ${themeColors.fg_primary};
      border: 1px solid ${themeColors.border_inactive};
      border-radius: 6px;
      padding: 8px 12px;
    }

    entry:focus {
      border-color: ${themeColors.accent_primary};
    }

    button {
      background-color: ${themeColors.accent_primary};
      color: ${themeColors.bg_primary};
      border-radius: 6px;
      padding: 8px 16px;
    }

    button:hover {
      background-color: ${themeColors.accent_secondary};
    }

    label {
      color: ${themeColors.fg_primary};
    }

    label.error {
      color: ${themeColors.color1};
    }

    combobox {
      background-color: ${themeColors.bg_tertiary};
      color: ${themeColors.fg_primary};
      border-radius: 6px;
    }
  '';
in
{
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/home/jtekk/Pictures/nix/huntress.png";
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
    extraCss = regreetCss;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
