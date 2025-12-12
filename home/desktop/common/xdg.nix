{ config, lib, pkgs, ... }:

{
  # XDG user directories - consistent across ALL DEs
  # This prevents backup conflicts when switching between DEs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    publicShare = "$HOME/Public";
    templates = "$HOME/Templates";
    videos = "$HOME/Videos";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Web
      "text/html" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/about" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/unknown" = [ "chromium-browser.desktop" ];
      "application/x-extension-htm" = [ "chromium-browser.desktop" ];
      "application/x-extension-html" = [ "chromium-browser.desktop" ];
      "application/x-extension-shtml" = [ "chromium-browser.desktop" ];
      "application/xhtml+xml" = [ "chromium-browser.desktop" ];
      "application/x-extension-xhtml" = [ "chromium-browser.desktop" ];
      "application/x-extension-xht" = [ "chromium-browser.desktop" ];

      # Documents
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-pdf" = [ "org.gnome.Evince.desktop" ];

      # Text
      "text/plain" = [ "nvim.desktop" "org.gnome.TextEditor.desktop" ];
      "text/x-markdown" = [ "nvim.desktop" "typora.desktop" ];
      "text/markdown" = [ "nvim.desktop" "typora.desktop" ];

      # Images
      "image/png" = [ "org.gnome.Loupe.desktop" "pinta.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" "pinta.desktop" ];
      "image/jpg" = [ "org.gnome.Loupe.desktop" "pinta.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" "pinta.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];

      # Video
      "video/mp4" = [ "mpv.desktop" "vlc.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" "vlc.desktop" ];
      "video/webm" = [ "mpv.desktop" "vlc.desktop" ];

      # Audio
      "audio/mpeg" = [ "mpv.desktop" "vlc.desktop" ];
      "audio/x-wav" = [ "mpv.desktop" "vlc.desktop" ];
      "audio/flac" = [ "mpv.desktop" "vlc.desktop" ];

      # Archives
      "application/zip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-gzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-bzip2" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar-compressed" = [ "org.gnome.FileRoller.desktop" ];

      # Directories
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

      # Terminal
      "application/x-terminal-emulator" = [ "kitty.desktop" ];
    };

    associations.added = {
      # Additional associations (lower priority than default)
      "text/plain" = [ "code.desktop" ];
      "application/pdf" = [ "chromium-browser.desktop" ];
    };
  };

  # Create desktop entries for applications that might not have them
  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      exec = "kitty nvim %F";
      terminal = false;
      categories = [ "Development" "TextEditor" ];
      mimeType = [ "text/plain" "text/x-markdown" ];
      icon = "nvim";
    };

    kitty = {
      name = "Kitty";
      genericName = "Terminal Emulator";
      exec = "kitty %u";
      terminal = false;
      categories = [ "System" "TerminalEmulator" ];
      icon = "kitty";
      actions = {
        new-window = {
          name = "New Window";
          exec = "kitty";
        };
      };
    };

    discord = {
      name = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      exec = "discord";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
      mimeType = [ "x-scheme-handler/discord" ];
      icon = "discord";
    };
  };

}
