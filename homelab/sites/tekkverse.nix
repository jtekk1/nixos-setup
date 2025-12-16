{ config, lib, pkgs, ... }:

{
  # Nginx reverse proxy for tekkverse.com
  # Container runs on port 8200, managed by deploy-controller

  services.nginx.virtualHosts."tekkverse.com" = {
    enableACME = true;  # HTTP-01 challenge for custom domain
    forceSSL = true;
    serverAliases = [ "www.tekkverse.com" ];

    locations."/" = {
      proxyPass = "http://127.0.0.1:8200";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };

  };

  # Preview environment for tekkverse (public)
  services.nginx.virtualHosts."preview.tekkverse.com" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8201";  # Preview port
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };

  # Stage environment (internal only - no ACME, self-signed)
  services.nginx.virtualHosts."stage.tekkverse.com" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";  # Use wildcard cert for internal

    locations."/" = {
      proxyPass = "http://127.0.0.1:8203";  # Stage port
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };

  # Dev environment (internal only - no ACME, self-signed)
  services.nginx.virtualHosts."dev.tekkverse.com" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";  # Use wildcard cert for internal

    locations."/" = {
      proxyPass = "http://127.0.0.1:8202";  # Dev port
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
