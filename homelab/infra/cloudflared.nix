{ config, lib, pkgs, ... }:

{
  # Cloudflare Tunnel - Zero Trust access to internal services
  #
  # This module uses the token-based approach where:
  # - Tunnel is created in Cloudflare Zero Trust dashboard
  # - Ingress rules are configured in the dashboard (not here)
  # - NixOS just runs cloudflared with the tunnel token
  #
  # Setup instructions:
  # 1. Go to Cloudflare Zero Trust dashboard: https://one.dash.cloudflare.com/
  # 2. Navigate to: Networks -> Tunnels
  # 3. Create a new tunnel (name it e.g., "homelab")
  # 4. Copy the tunnel token (long base64 string starting with "eyJ...")
  # 5. Add to secrets/common.yaml:
  #      cloudflare:
  #        tunnel_token: "eyJ...your-token-here..."
  # 6. Re-encrypt: sops secrets/common.yaml
  # 7. Deploy: colmena apply --on beelink
  #
  # Then configure ingress rules in Cloudflare dashboard:
  #   Public Hostname -> Service:
  #   - blocky.jtekk.dev -> http://localhost:4040 (Blocky dashboard)
  #   - *.jtekk.dev -> http://localhost:80 (nginx handles other services)
  #
  # Advantages of token-based approach:
  # - Simpler setup (no credentials file needed)
  # - Ingress rules managed in dashboard (easy to change without redeploy)
  # - Token contains all authentication info

  # Create a dedicated user for cloudflared
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    description = "Cloudflare Tunnel daemon user";
  };
  users.groups.cloudflared = {};

  # Systemd service for running the tunnel with token
  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel (token-based)";
    after = [ "network-online.target" "systemd-resolved.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "cloudflared";
      Group = "cloudflared";
      Restart = "always";
      RestartSec = "5s";

      # Load token from sops secret file
      # Using shell to read the token from file since cloudflared expects token as argument
      ExecStart = pkgs.writeShellScript "cloudflared-tunnel" ''
        exec ${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run \
          --token "$(cat ${config.sops.secrets."cloudflare/tunnel_token".path})"
      '';

      # Security hardening
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictSUIDSGID = true;
    };
  };

  # Ensure cloudflared can read the token
  sops.secrets."cloudflare/tunnel_token" = {
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0400";
  };

  # No firewall ports needed - cloudflared makes outbound connections only
  # This is the main advantage: no port forwarding or open ports required
}
