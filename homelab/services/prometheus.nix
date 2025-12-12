{ config, lib, pkgs, ... }:

{
  # Prometheus - Metrics collection and time-series database
  # https://prometheus.io/
  # Deployed on tank for storage capacity

  services.prometheus = {
    enable = true;
    port = 9191;
    listenAddress = "127.0.0.1";

    # Data retention
    retentionTime = "30d";

    # Scrape configs - collect metrics from all nodes and services
    scrapeConfigs = [
      # Node exporters (system metrics from all servers)
      {
        job_name = "node";
        static_configs = [{
          targets = [
            "192.168.0.250:9100"  # mini-me
            "192.168.0.251:9100"  # beelink
            "192.168.0.252:9100"  # tank
            "192.168.0.253:9100"  # deli
          ];
        }];
      }

      # Prometheus self-monitoring
      {
        job_name = "prometheus";
        static_configs = [{
          targets = [ "127.0.0.1:9191" ];
        }];
      }

      # Blocky DNS metrics
      {
        job_name = "blocky";
        static_configs = [{
          targets = [
            "192.168.0.250:4040"  # mini-me
            "192.168.0.251:4040"  # beelink
          ];
        }];
      }

      # Netdata metrics
      {
        job_name = "netdata";
        metrics_path = "/api/v1/allmetrics";
        params = {
          format = ["prometheus"];
        };
        static_configs = [{
          targets = [
            "192.168.0.250:19999"  # mini-me
            "192.168.0.251:19999"  # beelink
            "192.168.0.252:19999"  # tank
          ];
        }];
      }

      # nginx exporter
      {
        job_name = "nginx";
        static_configs = [{
          targets = [
            "192.168.0.251:9113"  # beelink
            "192.168.0.252:9113"  # tank
          ];
        }];
      }

      # PostgreSQL exporter
      {
        job_name = "postgres";
        static_configs = [{
          targets = [
            "192.168.0.251:9187"  # beelink (Miniflux)
            "192.168.0.252:9187"  # tank (Nextcloud, Paperless, Immich)
          ];
        }];
      }

      # Redis exporters
      {
        job_name = "redis";
        static_configs = [
          {
            targets = [ "192.168.0.252:9121" ];
            labels = {
              instance = "nextcloud";
            };
          }
          {
            targets = [ "192.168.0.252:9122" ];
            labels = {
              instance = "immich";
            };
          }
          {
            targets = [ "192.168.0.252:9123" ];
            labels = {
              instance = "paperless";
            };
          }
        ];
      }

      # Gitea built-in metrics
      {
        job_name = "gitea";
        metrics_path = "/metrics";
        static_configs = [{
          targets = [ "127.0.0.1:3001" ];
        }];
      }
    ];
  };

  # nginx virtual host
  services.nginx.virtualHosts."prometheus.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:9191";
    };
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 9191 ];
}
