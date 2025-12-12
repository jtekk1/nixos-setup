{ config, pkgs, ... }:

{
  # Enable ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.package = pkgs.zfs_unstable;  # Use unstable for kernel 6.17 support

  # ZFS services
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
    };
    trim.enable = true;
  };

  # ZFS kernel parameter tuning
  boot.kernelParams = [
    "zfs.zfs_arc_max=8589934592"  # 8GB ARC max (minime might have more RAM)
  ];

  # ZFS Event Daemon (ZED)
  services.zfs.zed = {
    enableMail = false;
    settings = {
      ZED_DEBUG_LOG = "/var/log/zed.debug.log";
      ZED_NOTIFY_VERBOSE = true;
      ZED_NOTIFY_DATA = true;
    };
  };

  # Storage configuration for MiniMe
  # Option 1: RAID-Z1 with all 4 drives (RECOMMENDED)
  # sudo zpool create -f -o ashift=12 -o autoexpand=on \
  #   -O compression=lz4 -O atime=off -O xattr=sa \
  #   -O acltype=posixacl -O mountpoint=/storage/nas \
  #   nas-pool raidz /dev/disk/by-id/xxx1 /dev/disk/by-id/xxx2 \
  #   /dev/disk/by-id/xxx3 /dev/disk/by-id/xxx4
  # Result: 12TB usable with single drive failure protection

  # Option 2: 3-drive RAID-Z1 + separate backup (YOUR REQUEST - RISKY)
  # Main pool (3 drives):
  # sudo zpool create -f -o ashift=12 -o autoexpand=on \
  #   -O compression=lz4 -O atime=off -O xattr=sa \
  #   -O acltype=posixacl -O mountpoint=/storage/nas \
  #   nas-pool raidz /dev/disk/by-id/xxx1 /dev/disk/by-id/xxx2 /dev/disk/by-id/xxx3
  # Result: 8TB usable

  # Backup pool (1 drive - NO REDUNDANCY):
  # sudo zpool create -f -o ashift=12 \
  #   -O compression=lz4 -O atime=off \
  #   -O mountpoint=/storage/backup \
  #   backup-pool /dev/disk/by-id/xxx4

  # Create datasets for different purposes
  # sudo zfs create nas-pool/nextcloud
  # sudo zfs create nas-pool/media
  # sudo zfs create nas-pool/documents
  # sudo zfs create nas-pool/backups
  # sudo zfs set recordsize=16k nas-pool/nextcloud  # Optimize for Nextcloud database

  # Auto-import pools on boot
  boot.zfs.extraPools = [ "nas-pool" ];  # Add "backup-pool" if using option 2

  # Automated backup between pools (if using option 2)
  # systemd.services.zfs-replicate = {
  #   description = "Replicate nas-pool to backup-pool";
  #   serviceConfig.Type = "oneshot";
  #   path = [ pkgs.zfs pkgs.sanoid pkgs.syncoid ];
  #   script = ''
  #     syncoid -r nas-pool backup-pool
  #   '';
  # };
  # systemd.timers.zfs-replicate = {
  #   wantedBy = [ "timers.target" ];
  #   partOf = [ "zfs-replicate.service" ];
  #   timerConfig = {
  #     OnCalendar = "daily";
  #     Persistent = true;
  #   };
  # };

  # Monitoring tools
  environment.systemPackages = with pkgs; [
    zfs
    zfs-autobackup
    sanoid  # Includes syncoid
    zfstools
  ];

  # Create mount points
  systemd.tmpfiles.rules = [
    "d /storage 0755 root root -"
    "d /storage/nas 0755 root root -"
    "d /storage/backup 0755 root root -"  # If using separate backup pool
  ];
}