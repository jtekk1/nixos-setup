{ config, lib, pkgs, ... }:

{
  # Netdata - Real-time performance and health monitoring
  # https://www.netdata.cloud/
  # Deployed on mini-me, beelink, tank
  #
  # NOTE: Netdata v2.5+ removed the web UI from the open-source version.
  # This deployment is metrics-only, scraped by Prometheus.
  # Visualize metrics in Grafana at grafana.jtekk.dev

  services.netdata = {
    enable = true;

    config = {
      global = {
        "default port" = "19999";
        "bind to" = "*";
        "memory mode" = "dbengine";
        "page cache size" = "32";
        "dbengine disk space" = "256";
      };

      web = {
        "mode" = "static-threaded";
        "listen backlog" = "4096";
        "default port" = "19999";
        "bind to" = "*";
      };
    };
  };

  # Firewall - only accessible via nginx proxy
  networking.firewall.allowedTCPPorts = [ 19999 ];
}
