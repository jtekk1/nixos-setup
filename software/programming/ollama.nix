{ pkgs, ... }:

{
  services.ollama = {
    enable = false;  # Temporarily disabled - may conflict with wlroots renderer
    # package = pkgs.ollama-rocm;  # ROCm acceleration (was: acceleration = "rocm")
  };
}
