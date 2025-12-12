{ config, lib, pkgs, ... }:

{
  # Miniflux - Minimalist RSS feed reader
  # https://miniflux.app/
  # Deployed on beelink

  # Secrets for admin credentials
  sops.secrets."miniflux/admin_credentials" = {
    sopsFile = ../../secrets/common.yaml;
    key = "miniflux/admin_credentials";
  };

  services.miniflux = {
    enable = true;

    # Auto-create PostgreSQL database
    createDatabaseLocally = true;

    # Admin credentials from sops
    # File format: ADMIN_USERNAME=admin\nADMIN_PASSWORD=yourpassword
    adminCredentialsFile = config.sops.secrets."miniflux/admin_credentials".path;

    config = {
      # Listen on localhost, nginx handles external
      LISTEN_ADDR = "127.0.0.1:8070";

      # Base URL for links
      BASE_URL = "https://rss.jtekk.dev";

      # Polling settings
      POLLING_FREQUENCY = "15";  # minutes
      BATCH_SIZE = "10";

      # Cleanup old entries
      CLEANUP_FREQUENCY_HOURS = "24";
      CLEANUP_ARCHIVE_READ_DAYS = "60";
      CLEANUP_ARCHIVE_UNREAD_DAYS = "180";

      # Security
      HTTPS = "1";

      # UI preferences
      POLLING_PARSING_ERROR_LIMIT = "3";
    };
  };

  # PostgreSQL for Miniflux (auto-configured by createDatabaseLocally)
  services.postgresql.enable = true;

  # nginx virtual host
  services.nginx.virtualHosts."rss.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:8070";
    };
  };

  # Firewall (nginx handles external, open for local access)
  networking.firewall.allowedTCPPorts = [ 8070 ];
}
