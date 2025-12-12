{ config, lib, pkgs, ... }:

{
  # Loki - Log aggregation system
  # https://grafana.com/oss/loki/
  # Deployed on tank for storage capacity

  services.loki = {
    enable = true;

    configuration = {
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = 3100;
      };

      auth_enabled = false;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
      };

      schema_config = {
        configs = [{
          from = "2024-01-01";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };

      storage_config = {
        tsdb_shipper = {
          active_index_directory = "/var/lib/loki/tsdb-index";
          cache_location = "/var/lib/loki/tsdb-cache";
        };
        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";  # 7 days
        retention_period = "720h";  # 30 days
      };

      table_manager = {
        retention_deletes_enabled = true;
        retention_period = "720h";  # 30 days
      };

      compactor = {
        working_directory = "/var/lib/loki/compactor";
        compaction_interval = "10m";
        retention_enabled = true;
        retention_delete_delay = "2h";
        retention_delete_worker_count = 150;
        delete_request_store = "filesystem";
      };
    };
  };

  # nginx virtual host
  services.nginx.virtualHosts."loki.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:3100";
      extraConfig = ''
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
      '';
    };
  };

  # Note: Port 3100 not exposed - all access goes through nginx (loki.jtekk.dev)
}
