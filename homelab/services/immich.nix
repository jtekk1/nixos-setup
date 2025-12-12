{ config, lib, pkgs, ... }:

{
  # Immich - Self-hosted photo and video management
  # https://immich.app/
  # Deployed on tank for bulk storage access

  services.immich = {
    enable = true;

    # Server binding
    host = "127.0.0.1";
    port = 2283;

    # Media storage - use bulk storage on tank
    # /var/lib/longhorn/bulk1 is 18TB
    mediaLocation = "/var/lib/longhorn/bulk1/immich";

    # Hardware acceleration (leave empty for software encoding)
    # Can add GPU paths later if needed: [ "/dev/dri/renderD128" ]
    accelerationDevices = [];

    # Machine learning for face detection and smart search
    machine-learning.enable = true;

    # Use built-in PostgreSQL and Redis
    database.enable = true;
    redis.enable = true;

    # Immich settings (managed via config, not web UI)
    settings = {
      # Disable version checking (privacy)
      newVersionCheck.enabled = false;

      # External domain for shared links
      server.externalDomain = "https://photos.jtekk.dev";
    };
  };

  # Ensure media directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/longhorn/bulk1/immich 0750 immich immich -"
  ];

  # nginx virtual host
  services.nginx.virtualHosts."photos.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 50G;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
      '';
    };
  };

  # Firewall (nginx handles external, but open for local access)
  networking.firewall.allowedTCPPorts = [ 2283 ];
}
