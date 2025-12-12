{ config, lib, pkgs, ... }:

{
  # Paperless-ngx - Document management system
  # https://docs.paperless-ngx.com/
  # Deployed on tank for bulk storage access

  # Secrets for admin password
  sops.secrets."paperless/admin_password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "paperless/admin_password";
    owner = "paperless";
    group = "paperless";
  };

  services.paperless = {
    enable = true;

    # Storage locations - use bulk storage on tank
    dataDir = "/var/lib/longhorn/bulk1/paperless";
    mediaDir = "/var/lib/longhorn/bulk1/paperless/media";
    consumptionDir = "/var/lib/longhorn/bulk1/paperless/consume";

    # Network settings
    address = "127.0.0.1";
    port = 28981;

    # Admin password from sops
    passwordFile = config.sops.secrets."paperless/admin_password".path;

    # Use PostgreSQL for better performance
    database.createLocally = true;

    # Enable Tika for Office documents and email parsing
    configureTika = true;

    settings = {
      # Base URL
      PAPERLESS_URL = "https://paperless.jtekk.dev";

      # Time zone
      PAPERLESS_TIME_ZONE = "America/New_York";

      # OCR settings
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_OCR_MODE = "skip";  # Skip if text already present

      # Task settings
      PAPERLESS_TASK_WORKERS = 2;
      PAPERLESS_THREADS_PER_WORKER = 2;

      # Security
      PAPERLESS_ADMIN_USER = "admin";

      # Consumption settings
      PAPERLESS_CONSUMER_RECURSIVE = true;
      PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
    };

    # Built-in exporter for backups
    exporter = {
      enable = true;
      directory = "/var/lib/longhorn/bulk1/paperless/export";
      onCalendar = "daily";
    };
  };

  # Ensure directories exist with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/longhorn/bulk1/paperless 0750 paperless paperless -"
    "d /var/lib/longhorn/bulk1/paperless/media 0750 paperless paperless -"
    "d /var/lib/longhorn/bulk1/paperless/consume 0750 paperless paperless -"
    "d /var/lib/longhorn/bulk1/paperless/export 0750 paperless paperless -"
  ];

  # nginx virtual host
  services.nginx.virtualHosts."paperless.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:28981";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 100M;
      '';
    };
  };

  # Firewall (nginx handles external, open for local access)
  networking.firewall.allowedTCPPorts = [ 28981 ];
}
