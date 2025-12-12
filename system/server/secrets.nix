{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # SOPS configuration
  sops = {
    defaultSopsFile = ../../secrets/common.yaml;

    # Use SSH host key for decryption
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Where to store decrypted secrets at runtime
    defaultSopsFormat = "yaml";

    # Secrets available to all servers
    # Secrets are decrypted to /run/secrets/<name> at boot
    secrets = {
      # User password hash
      "jtekk_password_hash" = { mode = "0400"; };

      # Tailscale auth key (expires: 2026-02-19)
      "tailscale/authkey" = {};

      # Cloudflare API token for ACME DNS challenge
      "cloudflare/api_token" = {};

      # Note: cloudflare/tunnel_token is defined in homelab/infra/cloudflared.nix
      # Only beelink (the gateway server) needs this secret

      # Authelia SSO secrets (owner set when service is enabled)
      "authelia/jwt_secret" = { mode = "0400"; };
      "authelia/session_secret" = { mode = "0400"; };
      "authelia/storage_encryption_key" = { mode = "0400"; };

      # Grafana admin password (owner set when service is enabled)
      "grafana/admin_password" = { mode = "0400"; };

      # Homepage dashboard API key
      "homepage/weather_api_key" = {};
    };
  };

  # Install sops for manual secret management
  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
