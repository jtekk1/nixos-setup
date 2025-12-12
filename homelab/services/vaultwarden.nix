{ config, lib, pkgs, ... }:

{
  # Vaultwarden - Bitwarden-compatible password manager
  # https://github.com/dani-garcia/vaultwarden

  sops.secrets."vaultwarden/admin_token" = {
    sopsFile = ../../secrets/common.yaml;
    key = "vaultwarden/admin_token";
  };

  # Create environment file from sops secret
  sops.templates."vaultwarden.env" = {
    content = ''
      ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin_token"}
    '';
    owner = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";

    # Environment file for sensitive values (ADMIN_TOKEN)
    environmentFile = config.sops.templates."vaultwarden.env".path;

    config = {
      # Domain configuration
      DOMAIN = "https://vault.jtekk.dev";

      # Server binding
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;

      # Security settings
      SIGNUPS_ALLOWED = false;           # Disable public signups
      INVITATIONS_ALLOWED = true;        # Allow invites from admin
      SHOW_PASSWORD_HINT = false;        # Don't show password hints

      # WebSocket notifications (for browser extension sync)
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_PORT = 3012;

      # Logging
      LOG_LEVEL = "info";
      EXTENDED_LOGGING = true;

      # Optional: Emergency access
      EMERGENCY_ACCESS_ALLOWED = true;

      # Optional: Send notifications
      # Requires SMTP configuration
      # SMTP_HOST = "";
      # SMTP_FROM = "";
    };

    # Backup configuration
    backupDir = "/var/backup/vaultwarden";
  };

  # Ensure backup directory exists
  systemd.tmpfiles.rules = [
    "d /var/backup/vaultwarden 0700 vaultwarden vaultwarden -"
  ];

  # nginx virtual host for Vaultwarden
  services.nginx.virtualHosts."vault.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";

    locations."/" = {
      proxyPass = "http://127.0.0.1:8222";
      proxyWebsockets = true;
    };

    # WebSocket endpoint for live sync
    locations."/notifications/hub" = {
      proxyPass = "http://127.0.0.1:3012";
      proxyWebsockets = true;
    };

    # Attachments endpoint
    locations."/notifications/hub/negotiate" = {
      proxyPass = "http://127.0.0.1:8222";
    };
  };

  # Open firewall for local access (nginx handles external)
  networking.firewall.allowedTCPPorts = [ 8222 3012 ];
}
