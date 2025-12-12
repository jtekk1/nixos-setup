# Homelab Service Allocation
# Central configuration of which services run on which hosts
# Imported by hive.nix for Colmena deployments

let
  roles = {

    # Infrastructure roles
    dns = [ ./infra/blocky.nix ];
    reverse-proxy = [ ./infra/nginx.nix ];
    ha-router = [ ./infra/cloudflared.nix ./infra/tailscale-subnet.nix ];
    postgres-metrics = [ ./infra/postgres-exporter.nix ];
    redis-metrics = [ ./infra/redis-exporter.nix ];
    backup-server = [ ./infra/restic-server.nix ];
    zfs-replication = [ ./infra/zfs-replication.nix ];

    # Service roles
    monitoring = [ ./services/netdata.nix ];
    ci-runner = [ ./services/gitea-actions-runner.nix ];
    observability =
      [ ./services/prometheus.nix ./services/loki.nix ./services/grafana.nix ];
  };

in {

  beelink = roles.dns ++ roles.reverse-proxy ++ roles.ha-router
    ++ roles.postgres-metrics ++ roles.monitoring ++ roles.ci-runner ++ [
      ./services/grafana.nix
      ./services/uptime-kuma.nix
      ./services/homepage.nix
      ./services/vaultwarden.nix
      ./services/miniflux.nix
      ./services/phpipam.nix
      ./services/home-assistant.nix
      ./services/blog.nix
      ./services/restic.nix
    ];

  mini-me = roles.dns ++ roles.ha-router ++ roles.monitoring
    ++ [ ./services/mailrise.ni ./services/restic-mini-me.nix ];

  tank = roles.reverse-proxy ++ roles.postgres-metrics ++ roles.redis-metrics
    ++ roles.backup-server ++ roles.zfs-replication ++ roles.monitoring
    ++ roles.ci-runner ++ [
      ./services/prometheus.nix
      ./services/loki.nix
      ./services/nextcloud.nix
      ./services/gitea.nix
      ./services/microbin.nix
      ./services/immich.nix
      ./services/paperless.nix
      ./services/restic-tank.nix
    ];
}
