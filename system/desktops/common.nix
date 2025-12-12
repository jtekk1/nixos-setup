{ pkgs, ... }:

{
  services.displayManager.cosmic-greeter.enable = true;

  # Enable PackageKit for package management tools (cosmic-store, etc.)
  services.packagekit.enable = true;

  # Enable XWayland for X11 app compatibility
  programs.xwayland.enable = true;

  # Ensure icon themes are available system-wide
  environment.pathsToLink = [ "/share/icons" ];

  # System-level Wayland packages
  environment.systemPackages = with pkgs; [
    # Display/Output
    wlr-randr
    swayosd

    # XWayland
    xwayland-satellite

    # GTK theming
    gnome-themes-extra
    gsettings-desktop-schemas

    # Qt Wayland
    libsForQt5.qt5.qtwayland

    # Icon themes
    papirus-icon-theme
  ];
}
