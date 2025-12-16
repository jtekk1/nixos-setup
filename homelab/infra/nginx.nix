{ config, lib, pkgs, ... }:

let
  domain = "jtekk.dev";
in
{
  # Nginx reverse proxy with Let's Encrypt SSL
  services.nginx = {
    enable = true;

    # Recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Status endpoint for Prometheus exporter
    statusPage = true;

    # Default server - reject unknown hosts
    virtualHosts."_" = {
      default = true;
      rejectSSL = true;
      locations."/".return = "444";
    };
  };

  # ACME (Let's Encrypt) with Cloudflare DNS challenge
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "admin@${domain}";
      dnsProvider = "cloudflare";
      # Use DNS challenge (works for internal services)
      dnsResolver = "1.1.1.1:53";
    };
    # Wildcard certificate for *.jtekk.dev
    certs."${domain}" = {
      domain = "*.${domain}";
      extraDomainNames = [ domain ];
      # Both DNS and Zone tokens can be the same scoped token
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets."cloudflare/api_token".path;
        "CLOUDFLARE_ZONE_API_TOKEN_FILE" = config.sops.secrets."cloudflare/api_token".path;
      };
    };
  };

  # Firewall - allow HTTP/HTTPS and nginx exporter
  networking.firewall.allowedTCPPorts = [ 80 443 9113 ];

  # Prometheus nginx exporter
  services.prometheus.exporters.nginx = {
    enable = true;
    port = 9113;
    # Scrape the local nginx status page
    scrapeUri = "http://localhost/nginx_status";
  };

  # Helper: Create a reverse proxy virtual host
  # Usage in other modules:
  #   services.nginx.virtualHosts."service.jtekk.dev" = {
  #     forceSSL = true;
  #     useACMEHost = "jtekk.dev";
  #     locations."/" = {
  #       proxyPass = "http://127.0.0.1:8080";
  #       proxyWebsockets = true;
  #     };
  #   };

  # Grant nginx access to the wildcard cert
  users.users.nginx.extraGroups = [ "acme" ];

  # Example: Blocky dashboard (test that nginx + SSL works)
  # Points to local Blocky instance on beelink
  services.nginx.virtualHosts."blocky.${domain}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4040";
    };
  };

  # Cockpit web interfaces for all hosts
  services.nginx.virtualHosts."cp-mini-me.${domain}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://192.168.0.250:9090";
      proxyWebsockets = true;
      extraConfig = "proxy_set_header X-Forwarded-Proto $scheme;";
    };
  };

  services.nginx.virtualHosts."cp-beelink.${domain}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9090";
      proxyWebsockets = true;
      extraConfig = "proxy_set_header X-Forwarded-Proto $scheme;";
    };
  };

  services.nginx.virtualHosts."cp-tank.${domain}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://192.168.0.252:9090";
      proxyWebsockets = true;
      extraConfig = "proxy_set_header X-Forwarded-Proto $scheme;";
    };
  };

}
