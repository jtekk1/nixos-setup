{ pkgs, config, ... }:

let
  mod = "SUPER";
  shiftMod = "${mod} SHIFT";
  shiftCtrl = "CTRL SHIFT";

  app = "uwsm app --";
  tty = "${app} kitty";
  terminal = tty;
  browser = "chromium";
  webapp = url: "${app} ${browser} --app=${url}";
  fileManager = "${terminal} superfile";

  # Webapp shortcuts using centralized webapp module
  wa = config.programs.webapps.apps;
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Apps bindings
      "${mod}, Return, exec, ${tty} --working-directory=$(open-terminal)"
      "${mod}, slash, exec, ${app} bitwarden"
      "${mod}, B, exec, ${terminal} btop"
      "${mod}, C, exec, ${app} cursor"
      "${mod}, D, exec, ${terminal} lazydocker"
      "${mod}, F, exec, ${fileManager}"
      "${mod}, M, exec, ${app} spotify"
      "${mod}, N, exec, ${terminal} nvim"
      "${mod}, O, exec, ${app} obsidian"
      "${mod}, T, exec, ${browser}"
      "${mod}, X, exec, ${terminal} claude"
      "${shiftCtrl}, 4, exec, hyprshot -m region --clipboard-only"
      "${shiftCtrl}, space, exec, ${webapp wa.nerdfonts-cheatsheet.url}"

      # Webapps bindings (managed by programs.webapps module)
      "${shiftMod}, A, exec, ${webapp wa.gemini.url}"
      "${shiftMod}, C, exec, ${webapp wa.claude.url}"
      "${shiftMod}, G, exec, ${webapp wa.chatgpt.url}"
      "${shiftMod}, H, exec, ${webapp wa.hbomax.url}"
      "${shiftMod}, I, exec, ${webapp wa.instagram.url}"
      "${shiftMod}, M, exec, ${webapp wa.zohomail.url}"
      "${shiftMod}, N, exec, ${webapp wa.netflix.url}"
      "${shiftMod}, T, exec, ${webapp wa.teams.url}"
      "${shiftMod}, U, exec, ${webapp wa.upwork.url}"
      "${shiftMod}, Y, exec, ${webapp wa.youtube.url}"

      # Wofi menus
      "${mod}, space, exec, ${app} wofi --show drun"
      "${mod}, R, exec, ${app} wofi --show run"
      "${mod}, V, exec, ~/.local/bin/wofi-clipboard-menu"
    ];
  };
}
