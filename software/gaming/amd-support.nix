{ pkgs, config, lib, ... }:

# AMD GPU Gaming and Graphics Support
# This module provides the full AMD graphics stack for gaming (Mesa, Vulkan, RADV)
# Used by: deepspace only
#
# For compute/ROCm support, see hardware/amd.nix (shared by all AMD systems)
{
  imports = [
    ./default.nix
  ];

  # Enable graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # AMD GPU packages
    extraPackages = with pkgs; [
      # AMD control and monitoring
      lact                    # AMD GPU control daemon

      # Mesa drivers (for OpenGL and Vulkan with RADV)
      mesa                    # Includes RADV Vulkan driver

      # Vulkan support
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      # Note: amdvlk has been deprecated, RADV is included in mesa

      # ROCm for compute (OpenCL, HIP) - gaming/graphics focused
      rocmPackages.clr
      rocmPackages.rocm-runtime
      # rocm-smi provided by hardware/amd.nix (compute layer)

      # Video acceleration
      libva
      libva-utils
      libva-vdpau-driver
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa                    # Includes 32-bit drivers
      vulkan-loader
      libva
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Enable AMD GPU kernel modules
  boot.kernelModules = [ "amdgpu" ];

  # Kernel parameters for better AMD GPU support
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"  # Enable all power features
    "amdgpu.dc=1"                       # Enable display core
  ];

  # Environment variables for AMD GPU
  environment.variables = {
    # Use RADV (Mesa) Vulkan driver by default (generally more compatible)
    # Comment out to use AMDVLK instead
    AMD_VULKAN_ICD = "RADV";

    # Enable variable rate shading and other performance features
    # Optimized for RDNA 3+ (RX 7000/9000 series)
    RADV_PERFTEST = "gpl,nggc,rt";  # Added rt for ray tracing support
  };

  # Additional packages for AMD GPU users
  environment.systemPackages = with pkgs; [
    radeontop     # AMD GPU usage monitor
    corectrl      # GUI for GPU control
    gpu-viewer    # GUI for GPU information
  ];
}
