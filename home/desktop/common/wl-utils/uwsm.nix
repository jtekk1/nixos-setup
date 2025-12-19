{ pkgs, config, ... }:

{
  # UWSM (Universal Wayland Session Manager) configuration

  # Environment variables for uwsm
  xdg.configFile."uwsm/env".text = ''
    export TERMINAL=foot
  '';
}

