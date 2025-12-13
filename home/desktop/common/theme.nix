{ pkgs, config, lib, ... }:

let
  customIcons = pkgs.callPackage ../../../home/assets/icons { };
  colors = config.colorScheme.palette or (import ../../../themes/neuro-fusion.nix);
in
{
  # Theme packages (fonts are provided by system/defaults/fonts.nix)
  home.packages = with pkgs; [
    yaru-theme
    candy-icons
    papirus-icon-theme
    bibata-cursors
    adwaita-qt
    qgnomeplatform
    customIcons
  ];

  # Cursor configuration
  home.pointerCursor = {
    name = "Yaru";
    package = pkgs.yaru-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Session variables (minimal, compositor-agnostic)
  home.sessionVariables = {
    XCURSOR_THEME = "Yaru";
    XCURSOR_SIZE = "24";

    # Qt/GTK Wayland hints
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";

    # XCompose File
    XCOMPOSEFILE = "${config.home.homeDirectory}/.XCompose";
  };

  # GTK Theme configuration
  gtk = {
    enable = true;

    cursorTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
      size = 24;
    };

    theme = {
      name = "Yaru-dark";
      package = pkgs.yaru-theme;
    };

    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };

    font = {
      name = "Noto Sans";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk3.extraCss = ''
      /* Override selection colors to match neuro-fusion theme */
      selection,
      *:selected,
      *:selected:focus {
        background-color: ${colors.selection_bg};
        color: ${colors.selection_fg};
      }

      /* Text selection specifically */
      textview text selection,
      entry selection,
      label selection {
        background-color: ${colors.selection_bg};
        color: ${colors.selection_fg};
      }
    '';

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraCss = ''
      /* Override selection colors to match neuro-fusion theme */
      selection,
      *:selected,
      *:selected:focus {
        background-color: ${colors.selection_bg};
        color: ${colors.selection_fg};
      }

      /* Text selection specifically */
      textview text selection,
      entry selection,
      label selection {
        background-color: ${colors.selection_bg};
        color: ${colors.selection_fg};
      }
    '';
  };

  # Qt Theme configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # Font configuration
  fonts.fontconfig.enable = true;

  # dconf settings for GNOME/GTK apps
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Yaru";
      cursor-size = 24;
      color-scheme = "prefer-dark";
      gtk-theme = "Yaru-dark";
      icon-theme = "candy-icons";
      font-name = "Noto Sans 11";
      document-font-name = "Noto Sans 11";
      monospace-font-name = "CaskaydiaMono Nerd Font 11";
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Noto Sans Bold 11";
    };
  };
}