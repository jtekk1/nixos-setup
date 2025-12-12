{ config, pkgs, ... }:

{
  # Enable ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # ZFS services
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    autoSnapshot = {
      enable = true;
      frequent = 4;  # Keep 4 15-minute snapshots
      hourly = 24;   # Keep 24 hourly snapshots
      daily = 7;     # Keep 7 daily snapshots
      weekly = 4;    # Keep 4 weekly snapshots
      monthly = 12;  # Keep 12 monthly snapshots
    };
    trim.enable = true;  # For SSDs
  };

  # ZFS kernel parameter tuning
  boot.kernelParams = [
    "zfs.zfs_arc_max=34359738368"  # 32GB ARC max (adjust based on your RAM)
    "zfs.zfs_arc_min=4294967296"   # 4GB ARC min
  ];

  # ZFS Event Daemon (ZED) for monitoring
  services.zfs.zed = {
    enableMail = false;  # Set to true if you want email alerts
    settings = {
      ZED_DEBUG_LOG = "/var/log/zed.debug.log";

      # Notify on these events
      ZED_NOTIFY_VERBOSE = true;
      ZED_NOTIFY_DATA = true;
    };
  };

  # Storage pools configuration
  # NOTE: These are examples - adjust device paths to match your hardware

  # After you identify your drives, create pools with:
  # For HDDs (RAID-Z1 with 5 drives):
  # sudo zpool create -f -o ashift=12 -o autoexpand=on \
  #   -O compression=lz4 -O atime=off -O xattr=sa \
  #   -O acltype=posixacl -O mountpoint=/storage/bulk \
  #   bulk-pool raidz /dev/disk/by-id/xxx1 /dev/disk/by-id/xxx2 \
  #   /dev/disk/by-id/xxx3 /dev/disk/by-id/xxx4 /dev/disk/by-id/xxx5

  # For NVMEs (mirror for fast storage):
  # sudo zpool create -f -o ashift=12 \
  #   -O compression=lz4 -O atime=off \
  #   -O mountpoint=/storage/fast \
  #   fast-pool mirror /dev/disk/by-id/nvme1 /dev/disk/by-id/nvme2

  # OR: Add NVMEs as special vdev to HDD pool for metadata (recommended):
  # sudo zpool add bulk-pool special mirror /dev/disk/by-id/nvme1 /dev/disk/by-id/nvme2

  # ZFS datasets (create after pools exist)
  # sudo zfs create bulk-pool/vms
  # sudo zfs create bulk-pool/containers
  # sudo zfs create bulk-pool/backups
  # sudo zfs set quota=1T bulk-pool/backups  # Set quotas as needed

  # Auto-import pools on boot
  # IMPORTANT: Uncomment the line below after you've created your ZFS pools
  # boot.zfs.extraPools = [ "tank" "fast" ];  # Plan B dual pools

  # To create ZFS pools after boot, use commands like:
  # sudo zpool create -o ashift=12 bulk-pool raidz2 /dev/disk/by-id/...
  # sudo zpool create -o ashift=12 fast-pool mirror /dev/disk/by-id/...

  # Monitoring tools
  environment.systemPackages = with pkgs; [
    zfs
    zfs-autobackup  # For automated backups between pools
    sanoid          # Snapshot management (includes syncoid for replication)
    zfstools
  ];

  # Create mount points
  systemd.tmpfiles.rules = [
    "d /storage 0755 root root -"
    "d /storage/bulk 0755 root root -"
    "d /storage/fast 0755 root root -"
  ];
}