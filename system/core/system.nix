{ config, lib, pkgs, ... }:

{
  time.timeZone = "America/Denver";
  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = with pkgs; [
    polkit_gnome # Authentication agent for graphical apps
    xdg-utils # Core desktop integration scripts
    zip
    unzip
    plocate
    procps # Standard ps, top, and other process utilities
    gcc # GNU Compiler Collection
    ncdu
  ];

  system.stateVersion = "25.11";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +15";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # Trust deploy user for Colmena remote deployments (allows unsigned store paths)
    trusted-users = [ "root" "deploy" ];
  };

  # Enable direnv with nix-direnv support for all systems
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
