{ config, lib, pkgs, ... }:

{
  # Restic backup receiver - accepts SFTP connections from beelink/mini-me
  # Runs on tank only

  # Create backup user with restricted shell
  users.users.restic-backup = {
    isSystemUser = true;
    group = "restic-backup";
    home = "/zfs/backups/restic";
    createHome = false;
    shell = "/run/current-system/sw/bin/nologin";
    openssh.authorizedKeys.keyFiles = [
      ../../keys/restic-beelink.pub
      ../../keys/restic-mini-me.pub
    ];
  };

  users.groups.restic-backup = {};

  # Ensure backup directories exist with correct permissions
  # /zfs/backups must be root-owned for chroot to work
  systemd.tmpfiles.rules = [
    "d /zfs/backups 0755 root root -"
    "d /zfs/backups/restic 0755 restic-backup restic-backup -"
    "d /zfs/backups/restic/beelink 0700 restic-backup restic-backup -"
    "d /zfs/backups/restic/mini-me 0700 restic-backup restic-backup -"
  ];

  # SSH hardening for restic-backup user (restrict to SFTP only)
  services.openssh.extraConfig = ''
    Match User restic-backup
      ForceCommand internal-sftp
      ChrootDirectory /zfs/backups
      AllowTcpForwarding no
      X11Forwarding no
      PasswordAuthentication no
  '';
}
