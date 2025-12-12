{ config, pkgs, libs, ... }:

# AMD GPU Compute Support (ROCm)
# This module provides the ROCm stack for GPU compute workloads (AI/ML, OpenCL, HIP)
# Used by: tank, beelink, deepspace
#
# For gaming/graphics support, see software/gaming/amd-support.nix (deepspace only)
{
  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Core ROCm tools for compute
    rocmPackages.rocm-smi        # GPU monitoring and management CLI
    rocmPackages.rocminfo        # GPU information utility

    # Compute libraries (for AI/ML workloads)
    rocmPackages.tensile         # Tensor library
    rocmPackages.hipblaslt       # BLAS operations
    rocmPackages.rocm-device-libs # Device libraries
  ];
}
