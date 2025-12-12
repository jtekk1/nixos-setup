{ pkgs, config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Wallpaper management (unified-wallpaper)
      "SUPER ALT, W, exec, unified-wallpaper"  # Next wallpaper
      "SUPER ALT, P, exec, unified-wallpaper --prev"  # Previous wallpaper
      "SUPER ALT SHIFT, W, exec, unified-wallpaper --random"  # Random wallpaper
      "SUPER ALT, T, exec, unified-wallpaper --time"  # Time-based wallpaper
    ];
  };
}
