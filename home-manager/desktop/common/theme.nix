{ pkgs, config, lib, ... }:

let
  customIcons = pkgs.callPackage ../../../home-manager/assets/icons { };
  colors = config.theme.colors;
  nixSetupsPath = "${config.home.homeDirectory}/NixSetup";
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

  # Symlink custom cursor themes to icons directory (each theme individually)
  home.file = {
    ".local/share/icons/oreo_spark_pink_cursors".source =
      config.lib.file.mkOutOfStoreSymlink
      "${nixSetupsPath}/home-manager/assets/mouse-icons/oreo_spark_pink_cursors";
    ".local/share/icons/oreo_spark_purple_cursors".source =
      config.lib.file.mkOutOfStoreSymlink
      "${nixSetupsPath}/home-manager/assets/mouse-icons/oreo_spark_purple_cursors";
    ".local/share/icons/oreo_spark_blue_cursors".source =
      config.lib.file.mkOutOfStoreSymlink
      "${nixSetupsPath}/home-manager/assets/mouse-icons/oreo_spark_blue_cursors";
    ".local/share/icons/oreo_void_green_cursors".source =
      config.lib.file.mkOutOfStoreSymlink
      "${nixSetupsPath}/home-manager/assets/mouse-icons/oreo_void_green_cursors";
  };

  # Cursor configuration handled via symlinked directory and session variables
  # home.pointerCursor not used - custom cursors from ~/.local/share/icons

  # Session variables (minimal, compositor-agnostic)
  home.sessionVariables = {
    XCURSOR_THEME = "oreo_spark_pink_cursors";
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
      name = "oreo_spark_pink_cursors";
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
      /* Override selection colors to match theme */
      selection,
      *:selected,
      *:selected:focus {
        background-color: ${colors.accent_primary};
        color: ${colors.bg_primary};
      }

      /* Text selection specifically */
      textview text selection,
      entry selection,
      label selection {
        background-color: ${colors.accent_primary};
        color: ${colors.bg_primary};
      }
    '';

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraCss = ''
      /* Override selection colors to match theme */
      selection,
      *:selected,
      *:selected:focus {
        background-color: ${colors.accent_primary};
        color: ${colors.bg_primary};
      }

      /* Text selection specifically */
      textview text selection,
      entry selection,
      label selection {
        background-color: ${colors.accent_primary};
        color: ${colors.bg_primary};
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
      cursor-theme = "oreo_spark_pink_cursors";
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