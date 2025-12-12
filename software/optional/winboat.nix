{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.jtekk.software.winboat.enable {
    # Winboat requirements
    # Winboat runs Windows in a Docker container with KVM virtualization

    # Ensure Docker daemon is running
    systemd.services.docker = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
      };
    };

    # Enable KVM virtualization
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
      };
    };

    # Add required groups for the user
    users.users.jtekk.extraGroups = [
      "docker"    # For Docker access
      "libvirtd"  # For KVM virtualization
      "kvm"       # For KVM access
    ];

    environment.systemPackages = with pkgs; [
      # FreeRDP with audio support for RemoteApp
      freerdp

      # Docker compose (v2 is included with docker package)
      docker-compose

      # Winboat AppImage runner
      appimage-run

      # Shadow utilities (provides sg command for group switching)
      shadow

      # Helper script to download and run Winboat
      (writeShellScriptBin "winboat-install" ''
        #!/usr/bin/env bash
        set -e

        WINBOAT_DIR="$HOME/.local/share/winboat"

        echo "Creating Winboat directory..."
        mkdir -p "$WINBOAT_DIR"
        cd "$WINBOAT_DIR"

        echo "Downloading latest Winboat AppImage..."
        DOWNLOAD_URL=$(curl -s https://api.github.com/repos/TibixDev/winboat/releases/latest \
          | grep "browser_download_url.*AppImage" \
          | cut -d '"' -f 4)

        if [ -z "$DOWNLOAD_URL" ]; then
          echo "Error: Could not find latest Winboat release"
          exit 1
        fi

        echo "Downloading from: $DOWNLOAD_URL"
        curl -L -o winboat.AppImage "$DOWNLOAD_URL"
        chmod +x winboat.AppImage

        echo "Winboat installed successfully!"
        echo "You can run it with: $WINBOAT_DIR/winboat.AppImage"
      '')

      # Helper script to run Winboat
      (writeShellScriptBin "winboat" ''
        #!/usr/bin/env bash
        WINBOAT_DIR="$HOME/.local/share/winboat"
        if [ -f "$WINBOAT_DIR/winboat.AppImage" ]; then
          exec appimage-run "$WINBOAT_DIR/winboat.AppImage" "$@"
        else
          echo "Winboat not found. Please run 'winboat-install' first."
          exit 1
        fi
      '')

      # Fixed winboat launcher that ensures Docker group is active
      # This works around AppImage sandboxing issues with group detection
      (writeShellScriptBin "winboat-fixed" ''
        #!/usr/bin/env bash
        WINBOAT_DIR="$HOME/.local/share/winboat"

        if [ ! -f "$WINBOAT_DIR/winboat.AppImage" ]; then
          echo "Winboat not found. Please run 'winboat-install' first."
          exit 1
        fi

        # Run winboat with docker group explicitly active using sg (switch group)
        # This ensures the AppImage can detect Docker access properly
        exec ${pkgs.shadow}/bin/sg docker -c "${pkgs.appimage-run}/bin/appimage-run '$WINBOAT_DIR/winboat.AppImage' $*"
      '')
    ];

    # Enable nested virtualization for better performance
    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
    '';
    # For Intel CPUs, use: options kvm_intel nested=1
  };
}
