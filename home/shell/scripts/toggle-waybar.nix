{ pkgs, ... }:

{
  home.file.".local/bin/toggle-waybar" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      if pgrep -x "waybar" > /dev/null; then
          # Waybar is running, so kill it
          pkill -x waybar
      else
          # Waybar is not running, so start it
          waybar &> /dev/null &
      fi
    '';
  };
}
