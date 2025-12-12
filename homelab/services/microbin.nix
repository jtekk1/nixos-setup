{ config, lib, pkgs, ... }:

{
  # Microbin - Tiny, self-contained paste bin and URL shortener
  # https://github.com/szabodanika/microbin

  # Secrets from sops
  sops.secrets."microbin/admin_password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "microbin/admin_password";
  };
  sops.secrets."microbin/uploader_password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "microbin/uploader_password";
  };

  # Create environment file from sops secrets
  sops.templates."microbin.env" = {
    content = ''
      MICROBIN_ADMIN_USERNAME=admin
      MICROBIN_ADMIN_PASSWORD=${config.sops.placeholder."microbin/admin_password"}
      MICROBIN_UPLOADER_PASSWORD=${config.sops.placeholder."microbin/uploader_password"}
    '';
  };

  services.microbin = {
    enable = true;

    # Secrets via environment file
    passwordFile = config.sops.templates."microbin.env".path;

    settings = {
      # Server settings
      MICROBIN_PORT = 8081;
      MICROBIN_BIND = "127.0.0.1";
      MICROBIN_PUBLIC_PATH = "https://bin.jtekk.dev";

      # Security settings
      MICROBIN_PRIVATE = false;           # Require login to view pastes
      MICROBIN_EDITABLE = false;          # Allow editing pastes
      MICROBIN_READONLY = true;
      MICROBIN_ENABLE_READONLY = true;

      # Features
      MICROBIN_HIGHLIGHTSYNTAX = true;
      MICROBIN_QR = true;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_SHOW_READ_STATS = true;

      # Encryption
      MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
      MICROBIN_ENCRYPTION_SERVER_SIDE = true;
      MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB = 256;
      MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB = 2048;

      # Expiry settings
      MICROBIN_DEFAULT_EXPIRY = "24hour";
      MICROBIN_GC_DAYS = 90;
      MICROBIN_ETERNAL_PASTA = false;

      # Privacy (already defaults to true, but explicit)
      MICROBIN_DISABLE_TELEMETRY = true;
      MICROBIN_DISABLE_UPDATE_CHECKING = true;

      # UI
      MICROBIN_HIDE_HEADER = false;
      MICROBIN_HIDE_FOOTER = true;
      MICROBIN_HIDE_LOGO = true;
      MICROBIN_WIDE = false;
      MICROBIN_TITLE = "JTekk's Microbin's!";
    };
  };

  # nginx virtual host
  services.nginx.virtualHosts."bin.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:8081";
    };
  };

  # Open firewall for local access (nginx handles external)
  networking.firewall.allowedTCPPorts = [ 8081 ];
}
