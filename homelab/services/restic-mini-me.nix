{ config, lib, pkgs, ... }:

{
  # Restic backups for mini-me → tank
  # https://restic.net/

  # Sops secret for Restic password (shared across all hosts)
  sops.secrets."restic/password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "restic/password";
  };

  # SSH private key for SFTP to tank
  sops.secrets."restic/ssh_privkey_mini_me" = {
    sopsFile = ../../secrets/common.yaml;
    key = "restic/ssh_privkey_mini_me";
    mode = "0400";
  };

  services.restic.backups = {
    # Backup mini-me services to tank via SFTP (more secure than NFS)
    to-tank = {
      repository = "sftp:restic-backup@192.168.0.252:/restic/mini-me";
      passwordFile = config.sops.secrets."restic/password".path;

      # SSH key for SFTP connection
      extraOptions = [
        "sftp.command='ssh -i ${config.sops.secrets."restic/ssh_privkey_mini_me".path} -o StrictHostKeyChecking=accept-new -s restic-backup@192.168.0.252 sftp'"
      ];

      paths = [
        "/var/lib/mailrise"
        # Add other mini-me service data as needed
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
  };

}
