# Server monitoring and telemetry agents
# These run on all servers and report to central aggregators (Prometheus, Loki)
{ config, pkgs, lib, ... }:

{
  # Cockpit - Real-time server monitoring dashboard
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = {
      WebService = {
        # Allow direct access and nginx proxy access
        Origins = lib.mkForce
          "https://beelink:9090 https://tank:9090 https://mini-me:9090 wss://beelink:9090 wss://tank:9090 wss://mini-me:9090 https://cp-beelink.jtekk.dev https://cp-tank.jtekk.dev https://cp-mini-me.jtekk.dev wss://cp-beelink.jtekk.dev wss://cp-tank.jtekk.dev wss://cp-mini-me.jtekk.dev";
        ProtocolHeader = "X-Forwarded-Proto";
        ForwardedForHeader = "X-Forwarded-For";
        # Allow HTTP connections from nginx reverse proxy
        AllowUnencrypted = true;
      };
    };
  };

  # Prometheus Node Exporter - System metrics for monitoring
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    openFirewall = true;
    enabledCollectors = [ "systemd" "processes" ];
  };

  # Grafana Alloy - Unified telemetry agent (replaces Promtail)
  # Ships logs to Loki and can also collect metrics
  services.alloy.enable = true;

  # Alloy configuration file
  environment.etc."alloy/config.alloy".text = ''
    // Loki log shipping
    loki.source.journal "system_logs" {
      max_age = "12h"
      labels  = {
        job  = "systemd-journal",
        host = "${config.networking.hostName}",
      }
      forward_to = [loki.write.loki.receiver]
    }

    loki.write "loki" {
      endpoint {
        url = "https://loki.jtekk.dev/loki/api/v1/push"
      }
    }
  '';
}
