{ config, lib, pkgs, ... }:

{
  # Gitea - Lightweight self-hosted Git service
  # https://gitea.io/

  # PostgreSQL for Gitea
  services.postgresql.enable = true;

  # Sops secrets for Gitea admin user
  sops.secrets."gitea/admin_username" = {
    sopsFile = ../../secrets/common.yaml;
    key = "gitea/admin_username";
    owner = "gitea";
  };

  sops.secrets."gitea/admin_password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "gitea/admin_password";
    owner = "gitea";
  };

  sops.secrets."gitea/admin_email" = {
    sopsFile = ../../secrets/common.yaml;
    key = "gitea/admin_email";
    owner = "gitea";
  };

  services.gitea = {
    enable = true;
    package = pkgs.gitea;

    # State directory
    stateDir = "/var/lib/gitea";

    # Database: PostgreSQL for better concurrency
    database = {
      type = "postgres";
      createDatabase = true;
    };

    # LFS (Large File Storage)
    lfs.enable = true;

    settings = {
      # Server settings
      server = {
        DOMAIN = "git.jtekk.dev";
        ROOT_URL = "https://git.jtekk.dev/";
        HTTP_PORT = 3001;
        HTTP_ADDR = "0.0.0.0";  # Listen on all interfaces for LAN access (metrics monitoring)
        SSH_PORT = 22;
        SSH_DOMAIN = "git.jtekk.dev";
      };

      # Service settings
      service = {
        DISABLE_REGISTRATION = true;  # Admin creates accounts
        REQUIRE_SIGNIN_VIEW = false;  # Allow public repo viewing
        ENABLE_NOTIFY_MAIL = false;
      };

      # Session settings
      session = {
        COOKIE_SECURE = true;
      };

      # Repository settings
      repository = {
        DEFAULT_BRANCH = "main";
        DEFAULT_PRIVATE = "private";
      };

      # UI settings
      ui = {
        DEFAULT_THEME = "gitea-auto";
        SHOW_USER_EMAIL = false;
      };

      # Security
      security = {
        INSTALL_LOCK = true;  # Disable web installer
        MIN_PASSWORD_LENGTH = 12;
      };

      # Logging
      log = {
        LEVEL = "Info";
      };

      # Queue workers (PostgreSQL handles concurrency well)
      queue = {
        WORKERS = 8;
      };

      # Actions (CI/CD)
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";  # Use GitHub for actions (actions/checkout, etc.)
      };

      # Prometheus metrics
      metrics = {
        ENABLED = true;
        # Metrics are exposed at http://127.0.0.1:3001/metrics
        # No authentication token required (accessed via localhost only)
      };

      # Package registry (container images, etc.)
      packages = {
        ENABLED = true;
        LIMIT_TOTAL_OWNER_SIZE = -1;  # No limit per owner
        LIMIT_SIZE_CONTAINER = -1;    # No limit for container images
      };
    };
  };

  # Create admin user on first boot
  systemd.services.gitea-admin-user = {
    description = "Create Gitea admin user";
    wantedBy = [ "multi-user.target" ];
    after = [ "gitea.service" ];
    requires = [ "gitea.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "gitea";
    };

    script = ''
      # Wait for Gitea to be ready
      sleep 5

      # Check if admin user already exists
      if ! ${pkgs.gitea}/bin/gitea admin user list --admin -c ${config.services.gitea.stateDir}/custom/conf/app.ini | grep -q "$(cat ${config.sops.secrets."gitea/admin_username".path})"; then
        echo "Creating Gitea admin user..."
        ${pkgs.gitea}/bin/gitea admin user create \
          --admin \
          --username "$(cat ${config.sops.secrets."gitea/admin_username".path})" \
          --password "$(cat ${config.sops.secrets."gitea/admin_password".path})" \
          --email "$(cat ${config.sops.secrets."gitea/admin_email".path})" \
          -c ${config.services.gitea.stateDir}/custom/conf/app.ini
        echo "Admin user created successfully"
      else
        echo "Admin user already exists, skipping creation"
      fi
    '';
  };

  # nginx virtual host
  services.nginx.virtualHosts."git.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";

    # Block external access to metrics endpoint
    locations."/metrics" = {
      return = "403";
    };

    # Proxy everything else to Gitea
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 10G;
      '';
    };
  };

  # Firewall - allow LAN access to port 3001 for metrics monitoring
  networking.firewall.allowedTCPPorts = [ 3001 ];
}
