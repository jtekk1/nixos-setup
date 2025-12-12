# Base server configuration
# Core settings that apply to all headless servers
{ config, pkgs, lib, ... }:

{
  # Disable desktop-oriented services on servers
  services.flatpak.enable = lib.mkForce false;

  # Server packages
  environment.systemPackages = with pkgs; [
    restic # Backup tool - needs root access
  ];

  # Firewall
  networking.firewall.enable = true;

  # Automatic security updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "02:00";
  };

  # Enable fstrim for SSDs
  services.fstrim.enable = true;

  # Enable systemd-logind to handle power management properly
  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandlePowerKey = "poweroff";
        HandleRebootKey = "reboot";
      };
    };
  };

  # Servers can act as subnet routers
  services.tailscale.useRoutingFeatures = "server";
}
