{ pkgs, ... }:

{
  home.file.".local/bin/toggle-sunset" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Check if wlsunset is running
      if pgrep -x "wlsunset" > /dev/null; then
          # It is running, so kill it (Turn OFF)
          pkill -x wlsunset
          notify-send -t 2000 "Night Light" "Disabled"
      else
          # It is not running, so start it (Turn ON)
          # -T 4501 (Day) and -t 4500 (Night) effectively forces 4500K immediately
          wlsunset -T 4501 -t 4500 &
          notify-send -t 2000 "Night Light" "Enabled (4500K)"
      fi
    '';
  };
}
