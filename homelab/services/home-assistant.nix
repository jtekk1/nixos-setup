{ config, lib, pkgs, ... }:

{
  # Home Assistant - Home automation platform
  # https://www.home-assistant.io/

  services.home-assistant = {
    enable = true;

    # Use extraComponents to enable integrations
    extraComponents = [
      # Essentials
      "default_config"  # Recommended base components
      "met"            # Weather
      "radio_browser"  # Radio stations

      # Network discovery
      "zeroconf"
      "ssdp"
      "dhcp"

      # Integrations (add as needed)
      "esphome"        # ESPHome devices
      "mqtt"           # MQTT broker integration
      "homekit"        # HomeKit bridge
      "google_assistant" # Google Assistant

      # Media
      "spotify"
      "plex"

      # Notifications
      "mobile_app"
      "notify"
    ];

    # Extra packages needed by components
    extraPackages = python3Packages: with python3Packages; [
      # Add any additional Python packages here
    ];

    # Configuration
    config = {
      # Default config includes:
      # - Lovelace UI
      # - Mobile app support
      # - Automations
      # - Scripts
      # - Scenes
      default_config = {};

      # HTTP configuration
      http = {
        server_host = "0.0.0.0";
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        ip_ban_enabled = true;
        login_attempts_threshold = 5;
      };

      # Homeassistant configuration
      homeassistant = {
        name = "Home";
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        time_zone = "America/Denver";
        country = "US";

        # External URL for remote access
        external_url = "https://ha.jtekk.dev";
        internal_url = "http://127.0.0.1:8123";
      };

      # Recorder - SQLite database
      recorder = {
        db_url = "sqlite:////var/lib/hass/home-assistant_v2.db";
        purge_keep_days = 30;
        commit_interval = 1;
      };

      # History
      history = {};

      # Logbook
      logbook = {};

      # Frontend
      frontend = {
        themes = "!include_dir_merge_named themes";
      };

      # Enable configuration via UI
      config = {};

      # Automation
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      scene = "!include scenes.yaml";
    };
  };

  # Create required files and directories
  systemd.tmpfiles.rules = [
    "d /var/lib/hass 0750 hass hass -"
    "f /var/lib/hass/secrets.yaml 0640 hass hass -"
    "f /var/lib/hass/automations.yaml 0640 hass hass -"
    "f /var/lib/hass/scripts.yaml 0640 hass hass -"
    "f /var/lib/hass/scenes.yaml 0640 hass hass -"
  ];

  # Create YAML files before Home Assistant starts
  systemd.services.home-assistant.preStart = lib.mkAfter ''
    # Create secrets.yaml with proper YAML format
    if [ ! -s /var/lib/hass/secrets.yaml ]; then
      cat > /var/lib/hass/secrets.yaml << 'EOF'
# Secrets for Home Assistant
# Add your secrets here in YAML format

# Location secrets (placeholder values for Denver, CO)
latitude: 39.7392
longitude: -104.9903
elevation: 1609
EOF
    fi

    # Create automations.yaml if it doesn't exist
    if [ ! -f /var/lib/hass/automations.yaml ]; then
      echo "[]" > /var/lib/hass/automations.yaml
    fi

    # Create scripts.yaml if it doesn't exist
    if [ ! -f /var/lib/hass/scripts.yaml ]; then
      echo "{}" > /var/lib/hass/scripts.yaml
    fi

    # Create scenes.yaml if it doesn't exist
    if [ ! -f /var/lib/hass/scenes.yaml ]; then
      echo "[]" > /var/lib/hass/scenes.yaml
    fi
  '';

  # nginx virtual host
  services.nginx.virtualHosts."ha.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";

    locations."/" = {
      proxyPass = "http://127.0.0.1:8123";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_buffering off;
      '';
    };
  };

  # Open firewall for local access
  networking.firewall.allowedTCPPorts = [ 8123 ];
}
