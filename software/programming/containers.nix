{ config, pkgs, ... }:

{
  # Add related CLI/GUI tools to system packages
  environment.systemPackages = with pkgs; [
    # Distrobox
    distrobox
    boxbuddy

    # Podman Extras
    podman-tui
    podman-desktop
    podman-compose
    podman-bootc  # Bootable container development (bootc)
    xorriso       # Required by podman-bootc for ISO manipulation
    virtiofsd     # Required by podman machine for filesystem sharing

    lazydocker
    
    virt-viewer
  ];
}
