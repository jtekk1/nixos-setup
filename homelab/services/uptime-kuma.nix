{ config, lib, pkgs, ... }:

{
  # Uptime Kuma - Self-hosted monitoring tool
  # Tracks uptime of services and sends alerts

  services.uptime-kuma = {
    enable = true;
    appriseSupport = true;  # Enable notification support
    settings = {
      PORT = "3001";
      HOST = "0.0.0.0";  # Bind to all interfaces
      # Data stored in /var/lib/uptime-kuma
    };
  };

  # nginx virtual host for uptime-kuma
  services.nginx.virtualHosts."uptime.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;  # Required for real-time updates
      extraConfig = ''
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
      '';
    };
  };

  # status.jtekk.dev redirects to the homelab status page
  services.nginx.virtualHosts."status.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      return = "301 https://uptime.jtekk.dev/status/homelab";
    };
  };

  # Open firewall for local access (nginx handles external)
  networking.firewall.allowedTCPPorts = [ 3001 ];
}
