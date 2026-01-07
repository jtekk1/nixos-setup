{ pkgs, config, ... }:

{
  home.file.".local/bin/screenshot-area" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Screenshot area selection using shotman
      # shotman properly handles input to prevent click-through issues

      if [ "$1" = "--clipboard" ]; then
        # Copy to clipboard using shotman (-C flag)
        shotman -c region -C
      elif [ -n "$1" ]; then
        # Save to specified file
        # Note: shotman doesn't support custom file paths, so we use grim as fallback
        GEOMETRY=$(slurp -b '#00000001' 2>/dev/null)
        if [ -n "$GEOMETRY" ]; then
          grim -g "$GEOMETRY" "$1"
        fi
      else
        # Save to Pictures - shotman handles this by default
        shotman -c region
      fi
    '';
  };
}
