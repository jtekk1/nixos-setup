{ config, pkgs, ... }:

{
  # Hugo blog at blog.jtekk.dev
  # Auto-deployed via Gitea Actions
  # https://blog.jtekk.dev

  # Allow nginx user SSH access for Gitea Actions deployment
  users.users.nginx = {
    shell = pkgs.bash;  # Give nginx a shell for rsync deployment
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJo7dBRe+IgW01Nm8SFfsmfraPWNzXyIfOUbQ+cEIGO7 blog-gitea-actions@deploy"
    ];
  };

  # Ensure blog directory exists
  systemd.tmpfiles.rules = [
    "d /var/www/blog 0755 nginx nginx -"
    "d /var/www/blog/public 0755 nginx nginx -"
  ];

  # nginx virtual host
  services.nginx.virtualHosts."blog.jtekk.dev" = {
    forceSSL = true;
    useACMEHost = "jtekk.dev";

    root = "/var/www/blog/public";

    locations."/" = {
      index = "index.html";
      tryFiles = "$uri $uri/ =404";
    };

    # Security headers
    extraConfig = ''
      add_header X-Frame-Options "SAMEORIGIN" always;
      add_header X-Content-Type-Options "nosniff" always;
      add_header X-XSS-Protection "1; mode=block" always;
      add_header Referrer-Policy "no-referrer-when-downgrade" always;
    '';
  };
}
