# Cursor AppImage package
{ lib, pkgs, appImageLib }:

appImageLib.mkAppImage rec {
  pname = "cursor";
  version = "2.0.77";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/production/ba90f2f88e4911312761abab9492c42442117cfe/linux/x64/Cursor-${version}-x86_64.AppImage";
    sha256 = "1zd79bj3374fxgzn61y9s83jixfyn197r522ghxyg18572ddrgpy";
  };

  description = "AI-powered code editor built on VSCode";
  homepage = "https://cursor.com";
  license = lib.licenses.unfree;

  # Default environment variables for better compatibility
  extraEnv = {
    ELECTRON_DISABLE_GPU_SANDBOX = "1";  # Disable GPU sandbox for better compatibility
    LIBGL_ALWAYS_SOFTWARE = "0";         # Enable hardware acceleration
    XKB_DEFAULT_LAYOUT = "us";           # Help with keyboard layout detection
    NIXOS_OZONE_WL = "1";                # Enable Wayland support for Electron
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";  # Force Wayland platform
    GDK_BACKEND = "wayland";             # Force Wayland for GTK
  };

  # Desktop entry configuration
  desktopName = "Cursor";
  icon = "cursor";
  categories = [ "Development" "IDE" "TextEditor" ];
  mimeTypes = [
    "text/plain"
    "text/x-python"
    "text/x-javascript"
    "text/x-typescript"
    "text/x-markdown"
    "text/x-json"
    "text/x-yaml"
    "text/x-toml"
    "text/x-rust"
    "text/x-go"
    "text/x-java"
    "text/x-c"
    "text/x-cpp"
    "text/x-csharp"
  ];

  # Extra libraries that Cursor (Electron-based) might need
  extraPkgs = pkgs: with pkgs; [
    # Electron/Chromium dependencies
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxshmfence
    libnotify
    libappindicator-gtk3

    # X11 libraries for keyboard handling
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libxkbfile
    xorg.libxcb
    xorg.xkeyboardconfig

    # Additional graphics/rendering
    mesa
    libdrm
    libGL
    libGLU
    vulkan-loader

    # Audio support
    pipewire
    pulseaudio
    alsa-lib

    # System integration
    trash-cli  # For trash functionality
    xdg-utils  # For opening URLs/files
    procps    # For proper ps command

    # Additional Electron dependencies
    at-spi2-core
    at-spi2-atk
    dbus
    expat
    glib
    gtk3
    nspr
    nss
    pango
    cairo
    cups
    libdrm

    # Wayland support (if using Wayland)
    wayland
    libxkbcommon
  ];

  # Extra installation commands
  extraInstallCommands = ''
    # Try to extract icon from the AppImage
    ${pkgs.libarchive}/bin/bsdtar -xOf $src '*.png' > cursor.png 2>/dev/null || \
    ${pkgs.libarchive}/bin/bsdtar -xOf $src 'cursor.png' > cursor.png 2>/dev/null || \
    ${pkgs.libarchive}/bin/bsdtar -xOf $src 'usr/share/icons/hicolor/512x512/apps/cursor.png' > cursor.png 2>/dev/null || true

    if [ -f cursor.png ] && [ -s cursor.png ]; then
      mkdir -p $out/share/icons/hicolor/512x512/apps
      mv cursor.png $out/share/icons/hicolor/512x512/apps/
    fi
  '';
}