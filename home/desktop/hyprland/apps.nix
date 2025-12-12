{ pkgs, config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Window rules (Hyprland 0.52+ syntax)
    windowrule = [
      # Bitwarden
      "noscreenshare, class:^(Bitwarden)$"

      # Browser types - tagging
      "tag +chromium-based-browser, class:([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)"
      "tag +firefox-based-browser, class:([fF]irefox|zen|librewolf)"
      "opacity 1 0.97, tag:chromium-based-browser"
      "opacity 1 0.97, tag:firefox-based-browser"
      "opacity 1.0 1.0, initialTitle:((?i)(?:[a-z0-9-]+\\.)*youtube\\.com_/|app\\.zoom\\.us_/wc/home)"

      # JetBrains
      "size 50% 50%, class:(.*jetbrains.*)$, title:^$, floating:1"
      "noinitialfocus, class:^(.*jetbrains.*)$, title:^\\s$"
      "nofocus, class:^(.*jetbrains.*)$, title:^\\s$"

      # Picture-in-picture
      "tag +pip, title:(Picture.?in.?[Pp]icture)"
      "float, tag:pip"
      "pin, tag:pip"
      "size 600 338, tag:pip"
      "keepaspectratio, tag:pip"
      "bordersize 0, tag:pip"
      "opacity 1 1, tag:pip"
      "move 100%-w-40 4%, tag:pip"

      # QEMU
      "opacity 1 1, class:qemu"

      # RetroArch
      "fullscreen, class:com.libretro.RetroArch"
      "opacity 1 1, class:com.libretro.RetroArch"

      # Steam
      "float, class:steam"
      "center, class:steam, title:Steam"
      "opacity 1 1, class:steam"
      "size 1100 700, class:steam, title:Steam"
      "size 460 800, class:steam, title:Friends List"
      "idleinhibit fullscreen, class:^(steam_app.*)$"

      # System floating windows
      "tag +floating-window, class:(blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|About|TUI.float)"
      "tag +floating-window, class:(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), title:^(Open.*Files?|Open Folder|Save.*Files?|Save.*As|Save|All Files)"
      "float, tag:floating-window"
      "center, tag:floating-window"
      "size 800 600, tag:floating-window"

      # Fullscreen screensaver
      "fullscreen, class:Screensaver"

      # No transparency on media windows
      "opacity 1 1, class:^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
    ];

    layerrule = [
      # Hyprshot - disable animation for selection layer
      "noanim, selection"
    ];
  };
}
