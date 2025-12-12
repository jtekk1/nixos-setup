# Core AppImage system configuration and support
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.appimages;

  # Import our helper library
  appImageLib = import ./lib.nix { inherit lib pkgs; };
in
{
  options.programs.appimages = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable AppImage support on the system.
        This will install necessary dependencies and configure the system
        to run AppImages directly.
      '';
    };

    binfmt = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Register AppImage files with binfmt_misc to allow direct execution.
        When enabled, you can run AppImages directly without using appimage-run.
      '';
    };

    systemPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        List of AppImage packages to install system-wide.
        These are Nix-wrapped AppImages from the packages directory.
      '';
    };

    storePath = mkOption {
      type = types.path;
      default = "/var/lib/appimages";
      description = ''
        System-wide directory for storing managed AppImages.
        Used by the hybrid manager approach for non-Nix AppImages.
      '';
    };

    userStorePath = mkOption {
      type = types.str;
      default = "$HOME/.local/share/appimages";
      description = ''
        User-specific directory for storing AppImages.
        This is a template string that will be expanded for each user.
      '';
    };

    enableSystemIntegration = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable system integration features like desktop entries,
        MIME type associations, and icon theme support.
      '';
    };

    enableFuse = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable FUSE support for AppImage extraction.
        Required for most AppImages to function properly.
      '';
    };

    defaultLibraries = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        # Common libraries that AppImages might need
        glib
        nss
        nspr
        atk
        cups
        dbus
        expat
        libdrm
        libxkbcommon
        pango
        cairo
        alsa-lib
        at-spi2-core
        at-spi2-atk

        # X11/Wayland libraries
        xorg.libX11
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
        xorg.libXScrnSaver
        wayland

        # Graphics libraries
        libGL
        libGLU
        vulkan-loader

        # GTK/Qt support
        gtk3
        gtk4
        libappindicator-gtk3

        # Additional common dependencies
        librsvg
        libnotify
        libpulseaudio
        libuuid
        libsecret
        udev
        liberation_ttf
      ];
      description = ''
        Default libraries to make available to AppImages.
        These are commonly required dependencies that many AppImages expect.
      '';
    };

    extraLibraries = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        Additional libraries to make available to AppImages,
        beyond the default set.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Enable AppImage execution support through binfmt
    programs.appimage = {
      enable = true;
      binfmt = cfg.binfmt;
    };

    # Install appimage-run for manual execution
    environment.systemPackages = with pkgs; [
      appimage-run

      # Install any configured AppImage packages
    ] ++ cfg.systemPackages ++ (optionals cfg.enable [
      # Debug wrapper for AppImages
      (writeShellScriptBin "appimage-debug" ''
        #!/usr/bin/env bash
        # Debug wrapper for AppImages
        echo "AppImage Debug Wrapper"
        echo "====================="
        echo "AppImage: $1"
        echo "Arguments: ''${@:2}"
        echo ""
        echo "Environment:"
        echo "  APPIMAGE_EXTRACT_AND_RUN: $APPIMAGE_EXTRACT_AND_RUN"
        echo "  XDG_DATA_DIRS: $XDG_DATA_DIRS"
        echo "  PATH: $PATH"
        echo ""
        echo "Running with strace..."
        ${strace}/bin/strace -e openat ${appimage-run}/bin/appimage-run "$@" 2>&1 | grep -E "(ENOENT|successfully opened)"
      '')

      # Extract tool for AppImages
      (writeShellScriptBin "appimage-extract" ''
        #!/usr/bin/env bash
        # Extract an AppImage for inspection
        if [ $# -eq 0 ]; then
          echo "Usage: appimage-extract <appimage-file> [output-dir]"
          exit 1
        fi

        APPIMAGE="$1"
        OUTPUT="''${2:-$(basename "$APPIMAGE" .AppImage).extracted}"

        echo "Extracting $APPIMAGE to $OUTPUT..."
        "$APPIMAGE" --appimage-extract
        if [ -d "squashfs-root" ]; then
          mv squashfs-root "$OUTPUT"
          echo "Extracted to $OUTPUT"
        else
          echo "Extraction failed"
          exit 1
        fi
      '')
    ]) ++ (optional cfg.enableSystemIntegration (
      # Desktop entry for appimage-run
      makeDesktopItem {
        name = "appimage-run";
        desktopName = "AppImage Runner";
        comment = "Run an AppImage file";
        exec = "${appimage-run}/bin/appimage-run %f";
        icon = "application-x-executable";
        terminal = false;
        categories = [ "System" ];
        mimeTypes = [
          "application/vnd.appimage"
          "application/x-executable"
          "application/x-iso9660-appimage"
        ];
      }
    ));

    # Create system-wide AppImage storage directory
    system.activationScripts.appimage-dirs = mkIf (cfg.storePath != "/var/lib/appimages") ''
      mkdir -p ${cfg.storePath}
      chmod 755 ${cfg.storePath}
    '';

    # Enable FUSE support if requested
    boot.kernelModules = mkIf cfg.enableFuse [ "fuse" ];

    # Set up FUSE permissions
    security.wrappers = mkIf cfg.enableFuse {
      fusermount = {
        source = "${pkgs.fuse}/bin/fusermount";
        setuid = true;
        owner = "root";
        group = "root";
      };
      fusermount3 = {
        source = "${pkgs.fuse3}/bin/fusermount3";
        setuid = true;
        owner = "root";
        group = "root";
      };
    };

    # Environment variables for better AppImage compatibility
    environment.sessionVariables = mkIf cfg.enableSystemIntegration {
      # Ensure AppImages can find FUSE when it's disabled
      APPIMAGE_EXTRACT_AND_RUN = mkIf (!cfg.enableFuse) "1";
    };


    # Desktop integration for system-wide AppImages
    environment.pathsToLink = mkIf cfg.enableSystemIntegration [
      "/share/applications"
      "/share/icons"
      "/share/pixmaps"
      "/share/mime"
    ];


    # System-wide MIME type associations for AppImages
    environment.etc."xdg/mimeapps.list" = mkIf cfg.enableSystemIntegration {
      text = ''
        [Added Associations]
        application/vnd.appimage=appimage-run.desktop;
        application/x-executable=appimage-run.desktop;
        application/x-iso9660-appimage=appimage-run.desktop;
      '';
    };

  };
}
