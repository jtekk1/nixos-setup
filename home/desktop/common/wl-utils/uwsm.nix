{ pkgs, config, ... }:

{
  # UWSM (Universal Wayland Session Manager) configuration
  # Note: UWSM is enabled at system level via programs.hyprland.withUWSM = true

  # Environment variables for uwsm
  xdg.configFile."uwsm/env".text = ''
    export TERMINAL=foot
  '';
}

