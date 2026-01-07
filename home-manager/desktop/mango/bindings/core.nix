{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Core actions
    bind=SUPER+CTRL,r,reload_config
    bind=SUPER+ALT,m,quit
    bind=SUPER,Return,spawn,foot
    bind=SUPER+SHIFT,Return,spawn,kitty
    bind=CTRL+SHIFT,space,spawn,chromium --app=https://www.nerdfonts.com/cheat-sheet
  '';
}
