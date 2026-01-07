{ pkgs, ... }:

{
  home.file.".local/bin/toggle-waybar" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Kill all waybar instances and restart
      pkill -9 waybar 2>/dev/null
      sleep 0.2
      waybar &> /dev/null &
      disown
    '';
  };
}
