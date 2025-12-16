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
    };
  };

  # Preview environment for tekkverse (public)
  services.nginx.virtualHosts."preview.tekkverse.com" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8201";
    };
  };

  # Stage environment (internal only - no ACME, self-signed)
  services.nginx.virtualHosts."stage.tekkverse.com" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";

    locations."/" = {
      proxyPass = "http://127.0.0.1:8203";
    };
  };

  # Dev environment (internal only - no ACME, self-signed)
  services.nginx.virtualHosts."dev.tekkverse.com" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";

    locations."/" = {
      proxyPass = "http://127.0.0.1:8202";
    };
  };
}
