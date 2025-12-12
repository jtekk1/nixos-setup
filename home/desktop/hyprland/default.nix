{ pkgs, ... }:

{
  imports = [
    # Common Wayland tools are imported via desktop/default.nix
    # (hypridle, hyprlock, mako, theme, etc.)
    ./waybar.nix  # Hyprland-specific waybar configuration
    ./hyprpaper.nix
    ./bindings   # Modular bindings directory
    ./apps.nix
    ./general.nix
  ];

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
  };

  # Enable wallpaper management
  programs.wallpaper.enable = true;
}
