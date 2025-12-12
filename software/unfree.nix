{ config, lib, pkgs, ... }:

{
  # Enable unfree packages globally (required for hardware.enableAllFirmware)
  nixpkgs.config.allowUnfree = true;

  # Keep predicate for documentation of which unfree packages we explicitly use
  nixpkgs.config.allowUnfreePredicate = pkg:
    # Allow all firmware packages (needed for hardware.enableAllFirmware)
    (lib.hasInfix "firmware" (lib.getName pkg)) ||
    # Allow explicitly listed packages
    builtins.elem (lib.getName pkg) [
    # From steam.nix
    "steam"
    "steamcmd"
    "steam-unwrapped"

    # From editors.nix
    "cursor"
    "code-cursor"
    "jetbrains-toolbox"
    "zed-editor"

    # From Apps
    "obsidian"
    "typora"
    "spotify"
    "bitwarden"
    "bitwarden-desktop"

    # AI Tools 
    "claude-code"
    "discord"
    "crush"

   # OTHER
   "chromium"
   "chromium-unwrapped"  # Needed when Widevine DRM is enabled
   "widevine-cdm"  # DRM for streaming services
  ];
}
