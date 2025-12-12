{ pkgs, config, ... }:

let
  baseWallpapers = [
    "/home/jtekk/NixSetups/home/assets/backgrounds/1.png"
    "/home/jtekk/NixSetups/home/assets/backgrounds/2.png"
    "/home/jtekk/NixSetups/home/assets/backgrounds/3.png"
  ];

  icyBlueWallpapers = [
    "/home/jtekk/NixSetups/home/assets/backgrounds/6-draggo.png"
    "/home/jtekk/NixSetups/home/assets/backgrounds/7-draggo.png"
    "/home/jtekk/NixSetups/home/assets/backgrounds/8-draggo.png"
  ];

  wallpapers = if config.theme.name == "icy-blue"
               then baseWallpapers ++ icyBlueWallpapers
               else baseWallpapers;

  defaultWallpaper = if config.theme.name == "icy-blue"
                     then "/home/jtekk/NixSetups/home/assets/backgrounds/7-draggo.png"
                     else "/home/jtekk/NixSetups/home/assets/backgrounds/1.png";
in
{
  # Enable the hyprpaper service
  services.hyprpaper = {
    enable = true;
    settings = {
      # Preload all wallpapers from the directory
      preload = wallpapers;
      wallpaper = ", ${defaultWallpaper}";
    };
  };
}
