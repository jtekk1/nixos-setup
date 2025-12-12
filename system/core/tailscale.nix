{ config, lib, pkgs, ... }:

let
  # Check if sops-nix is available (servers have it, desktops don't)
  hasSops = config ? sops && config.sops.secrets ? "tailscale/authkey";
in
{
  # Tailscale - Zero-config VPN for secure access
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";  # "server" for subnet routing
  };

  # Auto-authenticate using sops secret (servers only)
  # This runs once on first boot or when logged out
  # Desktops authenticate manually via `tailscale up`
  systemd.services.tailscale-autoconnect = lib.mkIf hasSops {
    description = "Automatic connection to Tailscale";
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    path = [ config.services.tailscale.package pkgs.jq ];
    script = ''
      # Wait for tailscaled to be ready
      sleep 2

      # Check if already authenticated
      status="$(tailscale status -json | jq -r .BackendState)"
      if [ "$status" = "NeedsLogin" ]; then
        tailscale up --authkey=$(cat ${config.sops.secrets."tailscale/authkey".path})
      fi
    '';
  };

  # Trust Tailscale interface for firewall
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
