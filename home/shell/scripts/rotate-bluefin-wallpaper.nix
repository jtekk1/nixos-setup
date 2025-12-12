{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "rotate-bluefin-wallpaper" ''
  #!/usr/bin/env bash

  # Rotate through Bluefin dino wallpapers based on time of day

  WALLPAPER_DIR="$HOME/Pictures/bluefin-dinos"

  # Check if directory exists
  if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
  fi

  # Get current hour
  HOUR=$(date +%H)

  # Select day or night wallpapers based on time
  if [ $HOUR -ge 6 ] && [ $HOUR -lt 18 ]; then
    # Daytime (6am-6pm) - use day wallpapers
    PATTERN="*-day.png"
  else
    # Nighttime - use night wallpapers
    PATTERN="*-night.png"
  fi

  # Get random wallpaper matching pattern
  WALLPAPER=$(find "$WALLPAPER_DIR" -name "$PATTERN" | shuf -n 1)

  if [ -z "$WALLPAPER" ]; then
    echo "No wallpaper found matching pattern: $PATTERN"
    exit 1
  fi

  # Set wallpaper with smooth fade transition
  ${pkgs.swww}/bin/swww img "$WALLPAPER" \
    --transition-type fade \
    --transition-duration 3 \
    --transition-fps 60

  echo "Wallpaper changed to: $(basename "$WALLPAPER")"
    '')
  ];
}
