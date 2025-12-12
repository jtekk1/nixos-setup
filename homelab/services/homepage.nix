{ config, lib, pkgs, ... }:

{
  # Homepage - A modern, self-hosted application dashboard
  # https://gethomepage.dev/

  # Sops secrets for Homepage API widgets (optional - widgets work without them too)
  sops.secrets."homepage/gitea_user" = {
    sopsFile = ../../secrets/common.yaml;
    key = "homepage/gitea_user";
  };

  sops.secrets."homepage/gitea_password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "homepage/gitea_password";
  };

  # Create environment file for Homepage widgets
  sops.templates."homepage.env" = {
    content = ''
      HOMEPAGE_VAR_GITEA_USER=${config.sops.placeholder."homepage/gitea_user"}
      HOMEPAGE_VAR_GITEA_PASSWORD=${config.sops.placeholder."homepage/gitea_password"}
    '';
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = 3000;
    openFirewall = true;

    # Restrict to actual hostname (prevents Host header injection)
    allowedHosts = "home.jtekk.dev";

    # Homepage settings
    settings = {
      title = "Homelab";
      favicon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/homepage.png";
      headerStyle = "boxed";
      layout = {
        Infrastructure = {
          style = "row";
          columns = 4;
        };
        Monitoring = {
          style = "row";
          columns = 3;
        };
        Services = {
          style = "row";
          columns = 3;
        };
      };
    };

    # Widgets for the top of the page
    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];

    # Service definitions
    services = [
      {
        Infrastructure = [
          {
            Blocky = {
              icon = "blocky";
              href = "https://blocky.jtekk.dev";
              description = "DNS ad-blocking";
              widget = {
                type = "customapi";
                url = "http://192.168.0.250:4040/api/blocking/status";
                refreshInterval = 10000;
                mappings = [
                  {
                    field = "enabled";
                    label = "Blocking";
                    format = "text";
                  }
                ];
              };
            };
          }
          {
            nginx = {
              icon = "nginx";
              href = "https://beelink.jtekk.dev";
              description = "Reverse proxy";
            };
          }
          {
            Cloudflared = {
              icon = "cloudflare";
              description = "Zero Trust tunnel";
            };
          }
          {
            Tailscale = {
              icon = "tailscale";
              description = "VPN mesh";
            };
          }
          {
            phpIPAM = {
              icon = "phpipam";
              href = "https://ipam.jtekk.dev";
              description = "IP address management";
            };
          }
        ];
      }
      {
        Monitoring = [
          {
            "Uptime Kuma" = {
              icon = "uptime-kuma";
              href = "https://uptime.jtekk.dev";
              description = "Service uptime monitoring";
              widget = {
                type = "uptimekuma";
                url = "http://127.0.0.1:3001";
                slug = "homelab";
              };
            };
          }
          {
            Grafana = {
              icon = "grafana";
              href = "https://grafana.jtekk.dev";
              description = "Metrics visualization";
              widget = {
                type = "grafana";
                url = "https://grafana.jtekk.dev";
                username = "{{HOMEPAGE_VAR_GRAFANA_USER}}";
                password = "{{HOMEPAGE_VAR_GRAFANA_PASSWORD}}";
              };
            };
          }
          {
            Prometheus = {
              icon = "prometheus";
              href = "https://prometheus.jtekk.dev";
              description = "Metrics collection";
            };
          }
          {
            Loki = {
              icon = "loki";
              href = "https://loki.jtekk.dev";
              description = "Log aggregation";
            };
          }
          {
            "Cockpit (beelink)" = {
              icon = "cockpit";
              href = "https://cp-beelink.jtekk.dev";
              description = "Server management";
            };
          }
          {
            "Cockpit (mini-me)" = {
              icon = "cockpit";
              href = "https://cp-mini-me.jtekk.dev";
              description = "Server management";
            };
          }
          {
            "Cockpit (tank)" = {
              icon = "cockpit";
              href = "https://cp-tank.jtekk.dev";
              description = "Server management";
            };
          }
          {
            "Cockpit (deli)" = {
              icon = "cockpit";
              href = "https://cp-deli.jtekk.dev";
              description = "Server management";
            };
          }
        ];
      }
      {
        Services = [
          {
            Vaultwarden = {
              icon = "vaultwarden";
              href = "https://vault.jtekk.dev";
              description = "Password manager";
            };
          }
          {
            Gitea = {
              icon = "gitea";
              href = "https://git.jtekk.dev";
              description = "Git hosting";
              widget = {
                type = "gitea";
                url = "https://git.jtekk.dev";
                username = "{{HOMEPAGE_VAR_GITEA_USER}}";
                password = "{{HOMEPAGE_VAR_GITEA_PASSWORD}}";
              };
            };
          }
          {
            Nextcloud = {
              icon = "nextcloud";
              href = "https://nc.jtekk.dev";
              description = "File storage";
              widget = {
                type = "nextcloud";
                url = "https://nc.jtekk.dev";
                username = "{{HOMEPAGE_VAR_NEXTCLOUD_USER}}";
                password = "{{HOMEPAGE_VAR_NEXTCLOUD_PASSWORD}}";
              };
            };
          }
          {
            Miniflux = {
              icon = "miniflux";
              href = "https://rss.jtekk.dev";
              description = "RSS reader";
              widget = {
                type = "miniflux";
                url = "https://rss.jtekk.dev";
                key = "{{HOMEPAGE_VAR_MINIFLUX_TOKEN}}";
              };
            };
          }
          {
            Immich = {
              icon = "immich";
              href = "https://photos.jtekk.dev";
              description = "Photo management";
              widget = {
                type = "immich";
                url = "https://photos.jtekk.dev";
                key = "{{HOMEPAGE_VAR_IMMICH_TOKEN}}";
              };
            };
          }
          {
            Paperless = {
              icon = "paperless";
              href = "https://paperless.jtekk.dev";
              description = "Document management";
              widget = {
                type = "paperlessngx";
                url = "https://paperless.jtekk.dev";
                username = "{{HOMEPAGE_VAR_PAPERLESS_USER}}";
                password = "{{HOMEPAGE_VAR_PAPERLESS_PASSWORD}}";
              };
            };
          }
          {
            Microbin = {
              icon = "pastebin";
              href = "https://bin.jtekk.dev";
              description = "Pastebin";
            };
          }
        ];
      }
    ];

    # Bookmarks section
    bookmarks = [
      {
        Developer = [
          { GitHub = [{ href = "https://github.com"; }]; }
          { NixOS = [{ href = "https://nixos.org"; }]; }
        ];
      }
    ];

    # Environment file for API tokens/credentials
    environmentFile = config.sops.templates."homepage.env".path;
  };

  # nginx virtual host for homepage
  services.nginx.virtualHosts."home.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
    };
  };
}
