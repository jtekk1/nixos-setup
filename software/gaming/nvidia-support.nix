# /path/to/your/config/nvidia-support.nix
{ pkgs, ... }:

{
  # Allow the proprietary NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

  # Use the proprietary NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl.enable = true;
  # CRITICAL: Enable 32-bit support for Steam and most games
  hardware.opengl.driSupport32Bit = true;

  # Recommended NVIDIA settings
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # May improve performance
    open = false; # Use the proprietary kernel module
    nvidiaSettings = true; # Install the nvidia-settings utility
  };
}
