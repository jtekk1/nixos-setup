{ config, lib, pkgs, ... }:

{
  # Restic backups for tank → tank (local)
  # https://restic.net/

  # Sops secret for Restic password (shared across all hosts)
  sops.secrets."restic/password" = {
    sopsFile = ../../secrets/common.yaml;
    key = "restic/password";
  };

  services.restic.backups = {
    # Local backup of tank services
    to-tank = {
      repository = "/tank/bulk/backups/restic/tank";
      passwordFile = config.sops.secrets."restic/password".path;

      paths = [
        "/var/lib/longhorn/bulk1/nextcloud"
        "/var/lib/gitea"
        "/var/lib/longhorn/bulk1/immich"
        "/var/lib/longhorn/bulk1/paperless"
        "/var/lib/microbin"
        "/var/lib/prometheus2"
        "/var/lib/loki"
        # Note: We're backing up service configs/DBs, not the bulk data
        # Nextcloud/Immich files use ZFS send to B2 for offsite backup
      ];

      exclude = [
        "*.log"
        "*.cache"
        "**/cache"
        "**/tmp"
        # Exclude large data directories (already protected by ZFS)
        "/var/lib/longhorn/bulk1/nextcloud/data"
        "/var/lib/longhorn/bulk1/immich/library"
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

  # Ensure backup directories exist for all hosts
  systemd.tmpfiles.rules = [
    "d /tank/bulk/backups 0750 root root -"
    "d /tank/bulk/backups/restic 0750 root root -"
    "d /tank/bulk/backups/restic/tank 0750 root root -"
    "d /tank/bulk/backups/restic/beelink 0750 root root -"
    "d /tank/bulk/backups/restic/mini-me 0750 root root -"
  ];
}
