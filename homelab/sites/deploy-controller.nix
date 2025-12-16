{ config, lib, pkgs, ... }:

let
  deployControllerScript = pkgs.writeScriptBin "deploy-controller" ''
    #!${pkgs.python3}/bin/python3
    ${builtins.readFile ./deploy-controller/deploy-controller.py}
  '';
in
{
  # Deploy token secret
  sops.secrets."sites/deploy_token" = {
    sopsFile = ../../secrets/common.yaml;
    key = "sites/deploy_token";
  };

  # Deploy controller service
  systemd.services.deploy-controller = {
    description = "Site Deployment Controller";
    after = [ "network-online.target" "podman.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      PORT = "9500";
      SITES_DIR = "/sites";
      STATE_DIR = "/var/lib/deploy-controller";
      REGISTRY = "git.jtekk.dev";
    };

    path = [ pkgs.podman ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${deployControllerScript}/bin/deploy-controller";
      Restart = "always";
      RestartSec = "10s";

      # Load deploy token from sops secret
      EnvironmentFile = config.sops.secrets."sites/deploy_token".path;

      # Run as root to manage podman containers
      # TODO: Consider using a dedicated user with podman access
      User = "root";

      # State directory
      StateDirectory = "deploy-controller";
    };
  };

  # Create sites directory
  systemd.tmpfiles.rules = [
    "d /sites 0755 root root -"
  ];

  # Open firewall for deploy controller (internal network only)
  networking.firewall.allowedTCPPorts = [ 9500 ];

  # Nginx reverse proxy for deploy controller API
  services.nginx.virtualHosts."deploy.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:9500";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
