{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;  # ROCm acceleration (was: acceleration = "rocm")
  };
}
