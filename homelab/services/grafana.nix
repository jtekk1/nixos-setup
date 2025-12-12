{ config, lib, pkgs, ... }:

{
  # Grafana - Metrics and logs visualization
  # https://grafana.com/
  # Deployed on beelink

  # Secrets for Grafana admin
  sops.secrets."grafana/admin_password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "grafana/admin_password";
    owner = "grafana";
    group = "grafana";
  };

  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3010;
        domain = "grafana.jtekk.dev";
        root_url = "https://grafana.jtekk.dev/";
      };

      security = {
        admin_user = "admin";
        admin_password = "$__file{${config.sops.secrets."grafana/admin_password".path}}";
      };

      analytics = {
        reporting_enabled = false;
        check_for_updates = false;
      };
    };

    provision = {
      enable = true;

      datasources.settings.datasources = [
        # Prometheus datasource
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "https://prometheus.jtekk.dev";
          isDefault = true;
          jsonData = {
            timeInterval = "1m";
          };
        }
        # Loki datasource
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "https://loki.jtekk.dev";
          jsonData = {
            maxLines = 1000;
          };
        }
      ];
    };
  };

  # nginx virtual host
  services.nginx.virtualHosts."grafana.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:3010";
      proxyWebsockets = true;
    };
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 3010 ];
}
