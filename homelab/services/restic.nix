{ config, lib, pkgs, ... }:

{
  # Restic - Fast, secure backup program
  # https://restic.net/

  # Sops secrets for Restic
  sops.secrets."restic/password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "restic/password";
  };

  sops.secrets."restic/b2_account_id" = {
    sopsFile = ../../secrets/common.yaml;
    key = "restic/b2_account_id";
  };

  sops.secrets."restic/b2_account_key" = {
    sopsFile = ../../secrets/common.yaml;
    key = "restic/b2_account_key";
  };

  # SSH private key for SFTP to tank
  sops.secrets."restic/ssh_privkey_beelink" = {
    sopsFile = ../../secrets/common.yaml;
    key = "restic/ssh_privkey_beelink";
    mode = "0400";
  };

  # Create environment file for Restic (B2 credentials)
  sops.templates."restic-b2.env" = {
    content = ''
      B2_ACCOUNT_ID=${config.sops.placeholder."restic/b2_account_id"}
      B2_ACCOUNT_KEY=${config.sops.placeholder."restic/b2_account_key"}
    '';
  };

  services.restic.backups = {
    # Backup to Tank via SFTP (more secure than NFS)
    to-tank = {
      repository = "sftp:restic-backup@192.168.0.252:/restic/beelink";
      passwordFile = config.sops.secrets."restic/password".path;

      # SSH key for SFTP connection
      extraOptions = [
        "sftp.command='ssh -i ${config.sops.secrets."restic/ssh_privkey_beelink".path} -o StrictHostKeyChecking=accept-new -s restic-backup@192.168.0.252 sftp'"
      ];

      paths = [
        "/var/lib/vaultwarden"
        "/var/lib/gitea"
        "/var/lib/hass"
        "/var/lib/miniflux"
        "/var/lib/grafana"
        "/var/lib/phpipam"
        "/var/lib/uptime-kuma"
      ];

      exclude = [
        "*.log"
        "*.cache"
        "**/cache"
        "**/tmp"
      ];

      timerConfig = {
        OnCalendar = "07:00";
        Persistent = true;
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 2"
      ];

      initialize = true;
    };

    # Cloud backup to Backblaze B2 (optional - enable when ready)
    # Uncomment and configure after creating B2 bucket
    # cloud = {
    #   repository = "b2:bucket-name:restic";
    #   passwordFile = config.sops.secrets."restic/password".path;
    #   environmentFile = config.sops.templates."restic-b2.env".path;
    #
    #   paths = [
    #     "/var/lib/vaultwarden"
    #     "/var/lib/gitea"
    #     "/var/lib/hass"
    #   ];
    #
    #   exclude = [
    #     "*.log"
    #     "*.cache"
    #     "**/cache"
    #     "**/tmp"
    #   ];
    #
    #   timerConfig = {
    #     OnCalendar = "weekly";
    #     Persistent = true;
    #   };
    #
    #   pruneOpts = [
    #     "--keep-weekly 4"
    #     "--keep-monthly 12"
    #     "--keep-yearly 3"
    #   ];
    #
    #   initialize = true;
    # };
  };

}
