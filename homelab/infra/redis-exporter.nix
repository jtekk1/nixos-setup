{ config, lib, pkgs, ... }:

{
  # Redis Prometheus exporters
  # Monitor Redis instances for Nextcloud, Immich, and Paperless

  # Nextcloud Redis exporter
  services.prometheus.exporters.redis = {
    enable = true;
    port = 9121;
    # Connect to Nextcloud Redis Unix socket via extraFlags
    extraFlags = [ "--redis.addr=unix:///run/redis-nextcloud/redis.sock" ];
    # Run as nextcloud user to access the socket (Redis runs as nextcloud, not redis-nextcloud)
    user = "nextcloud";
    group = "nextcloud";
  };

  # Additional exporters for Immich and Paperless Redis
  # Since NixOS only supports one redis exporter instance natively,
  # we'll create additional systemd services manually

  systemd.services.prometheus-redis-exporter-immich = {
    description = "Prometheus Redis Exporter for Immich";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "redis-immich.service" ];
    requires = [ "redis-immich.service" ];

    serviceConfig = {
      Type = "simple";
      User = "redis-immich";
      Group = "redis-immich";
      ExecStart = "${pkgs.prometheus-redis-exporter}/bin/redis_exporter --redis.addr=unix:///run/redis-immich/redis.sock --web.listen-address=:9122";
      Restart = "always";
    };
  };

  systemd.services.prometheus-redis-exporter-paperless = {
    description = "Prometheus Redis Exporter for Paperless";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "redis-paperless.service" ];
    requires = [ "redis-paperless.service" ];

    serviceConfig = {
      Type = "simple";
      User = "redis-paperless";
      Group = "redis-paperless";
      ExecStart = "${pkgs.prometheus-redis-exporter}/bin/redis_exporter --redis.addr=unix:///run/redis-paperless/redis.sock --web.listen-address=:9123";
      Restart = "always";
    };
  };

  # Firewall - allow Prometheus to scrape the exporters
  networking.firewall.allowedTCPPorts = [ 9121 9122 9123 ];
}
