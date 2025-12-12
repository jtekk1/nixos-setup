{ config, lib, pkgs, networkConfig ? null, ... }:

# Tailscale Subnet Router
# Advertises the LAN (192.168.0.0/24) to Tailscale for remote access
# Enable on multiple nodes for HA (Tailscale will failover automatically)

let
  lanSubnet = if networkConfig != null then networkConfig.lan else "192.168.0.0/24";
in
{
  # Override the default client setting to server
  services.tailscale.useRoutingFeatures = lib.mkForce "server";

  # Enable IP forwarding (required for subnet routing)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Extend the autoconnect script to advertise routes
  systemd.services.tailscale-subnet = {
    description = "Tailscale subnet router advertisement";
    after = [ "tailscale.service" "tailscale-autoconnect.service" ];
    wants = [ "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [ config.services.tailscale.package pkgs.jq ];
    script = ''
      # Wait for tailscale to be ready
      sleep 5

      # Check if already authenticated
      status="$(tailscale status -json | jq -r .BackendState)"
      if [ "$status" = "Running" ]; then
        echo "Advertising subnet ${lanSubnet}..."
        # Subnet routers should NOT accept routes for their own LAN (causes routing loops)
        tailscale set --advertise-routes=${lanSubnet} --accept-routes=false
      else
        echo "Tailscale not running (status: $status), skipping subnet advertisement"
      fi
    '';
  };
}
