{ config, lib, pkgs, networkConfig ? null, ... }:

let
  # Get host IP if networkConfig is available, otherwise use 0.0.0.0
  hostIP = if networkConfig != null && config.networking.hostName != null
    then networkConfig.hosts.${config.networking.hostName}.ip or "0.0.0.0"
    else "0.0.0.0";
in
{
  # Blocky - Fast and lightweight DNS proxy with ad-blocking
  # Replaces Pi-hole with a pure NixOS solution

  services.blocky = {
    enable = true;
    settings = {
      # Upstream DNS servers (used when not blocked)
      upstreams = {
        groups = {
          default = [
            "https://dns.cloudflare.com/dns-query"  # Cloudflare DoH
            "https://dns.google/dns-query"          # Google DoH
            "1.1.1.1"                               # Cloudflare fallback
            "8.8.8.8"                               # Google fallback
          ];
        };
      };

      # Bootstrap DNS for initial DoH resolution
      bootstrapDns = [
        { upstream = "1.1.1.1"; }
        { upstream = "8.8.8.8"; }
      ];

      # Blocklists for ad/tracker blocking
      blocking = {
        denylists = {
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://adaway.org/hosts.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Easylist.txt"
          ];
          trackers = [
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
          ];
          malware = [
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"
            "https://v.firebog.net/hosts/RPiList-Malware.txt"
          ];
        };

        # Which client groups use which blocklists
        clientGroupsBlock = {
          default = [ "ads" "trackers" "malware" ];
        };

        # What to return for blocked queries
        blockType = "zeroIp";

        # How often to refresh blocklists
        loading = {
          refreshPeriod = "4h";
        };
      };

      # Caching for better performance
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };

      # Ports configuration
      # Bind to host IP and localhost to avoid conflicts with podman DNS
      ports = {
        dns = "${hostIP}:53,127.0.0.1:53";
        http = "${hostIP}:4040,127.0.0.1:4040";
      };

      # Logging
      log = {
        level = "info";
        format = "text";
      };

      # Prometheus metrics (for Grafana)
      prometheus = {
        enable = true;
        path = "/metrics";
      };

      # Custom DNS entries for internal services
      customDNS = {
        mapping = {
          # Homelab services on beelink
          "uptime.jtekk.dev" = "192.168.0.251";
          "home.jtekk.dev" = "192.168.0.251";
          "blocky.jtekk.dev" = "192.168.0.251";
          "vault.jtekk.dev" = "192.168.0.251";
          "rss.jtekk.dev" = "192.168.0.251";
          "ipam.jtekk.dev" = "192.168.0.251";
          "ha.jtekk.dev" = "192.168.0.251";
          "blog.jtekk.dev" = "192.168.0.251";
          "nc.jtekk.dev" = "192.168.0.252";
          "git.jtekk.dev" = "192.168.0.252";
          # Status page
          "status.jtekk.dev" = "192.168.0.251";
          # Paste bin
          "bin.jtekk.dev" = "192.168.0.252";
          # Photo management
          "photos.jtekk.dev" = "192.168.0.252";
          # Document management
          "paperless.jtekk.dev" = "192.168.0.252";
          # Monitoring
          "prometheus.jtekk.dev" = "192.168.0.252";
          "loki.jtekk.dev" = "192.168.0.252";
          "grafana.jtekk.dev" = "192.168.0.251";
          # Cockpit web interfaces
          # Cockpit proxies (all go through beelink nginx)
          "cp-mini-me.jtekk.dev" = "192.168.0.251";
          "cp-beelink.jtekk.dev" = "192.168.0.251";
          "cp-tank.jtekk.dev" = "192.168.0.251";
          "cp-deli.jtekk.dev" = "192.168.0.251";
          # Deploy controller (internal only)
          "deploy.jtekk.dev" = "192.168.0.251";
          # Tekkverse environments (internal only)
          "dev.tekkverse.com" = "192.168.0.251";
          "stage.tekkverse.com" = "192.168.0.251";
          # Server hostnames
          "beelink.jtekk.dev" = "192.168.0.251";
          "mini-me.jtekk.dev" = "192.168.0.250";
          "tank.jtekk.dev" = "192.168.0.252";
          "deli.jtekk.dev" = "192.168.0.253";
        };
      };
    };
  };

  # Open firewall for DNS
  networking.firewall = {
    allowedTCPPorts = [ 53 4040 ];
    allowedUDPPorts = [ 53 ];
  };
}
