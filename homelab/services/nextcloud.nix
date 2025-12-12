{ config, lib, pkgs, ... }:

{
  # Nextcloud - Self-hosted file storage and collaboration
  # https://nextcloud.com/
  # Deployed on tank for bulk storage access

  # Secrets for Nextcloud admin
  sops.secrets."nextcloud/admin_password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "nextcloud/admin_password";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;  # Latest stable
    hostName = "nc.jtekk.dev";

    # Use HTTPS (nginx handles SSL)
    https = true;

    # Data directory - use bulk storage
    # /var/lib/longhorn/bulk1 is 18TB
    home = "/var/lib/longhorn/bulk1/nextcloud";

    # Database: PostgreSQL (recommended for production)
    database.createLocally = true;

    # Redis caching for better performance
    configureRedis = true;

    # Admin account
    config = {
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/admin_password".path;

      # Database settings (auto-configured with createLocally)
      dbtype = "pgsql";
    };

    # PHP settings - maxUploadSize handles upload limits
    # Only override settings not auto-configured
    phpOptions = {
      "max_execution_time" = "3600";
      "max_input_time" = "3600";
    };

    # Nextcloud settings
    settings = {
      # Trusted domains (in addition to hostName)
      trusted_domains = [
        "nc.jtekk.dev"
        "192.168.0.252"
        "tank"
        "tank.jtekk.dev"
      ];

      # Default phone region
      default_phone_region = "US";

      # Logging
      log_type = "file";
      loglevel = 2;  # 0=debug, 1=info, 2=warn, 3=error

      # Performance
      memcache.local = "\\OC\\Memcache\\APCu";
      memcache.distributed = "\\OC\\Memcache\\Redis";
      memcache.locking = "\\OC\\Memcache\\Redis";

      # Background jobs via cron
      backgroundjobs_mode = "cron";

      # Maintenance window (3-4 AM local time)
      maintenance_window_start = 3;
    };

    # Auto-update apps
    autoUpdateApps.enable = true;
    autoUpdateApps.startAt = "04:00";

    # Max upload size for nginx
    maxUploadSize = "16G";

    # Enable recommended apps
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit calendar contacts notes tasks;
    };
    extraAppsEnable = true;
  };

  # PostgreSQL for Nextcloud
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };

  # Redis for caching
  services.redis.servers.nextcloud = {
    enable = true;
    user = "nextcloud";
  };

  # Ensure data directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/longhorn/bulk1/nextcloud 0750 nextcloud nextcloud -"
  ];

  # nginx virtual host (tank needs nginx.nix imported)
  services.nginx.virtualHosts."nc.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
