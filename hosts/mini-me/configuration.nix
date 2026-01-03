{ config, lib, pkgs, networkConfig, ... }:

let hostCfg = networkConfig.hosts.mini-me;
in {
  imports = [
    ./disko-config-zfs.nix # ZFS production config
    ../../system/server
  ];

  networking.hostName = "mini-me";
  networking.networkmanager.enable = false;

  # Force static IP configuration - disable ALL DHCP completely
  networking.useDHCP = lib.mkForce false;
  networking.dhcpcd.enable = lib.mkForce false;

  networking.interfaces.${hostCfg.interface} = {
    useDHCP = lib.mkForce false;
    ipv4.addresses = [{
      address = hostCfg.ip;
      prefixLength = networkConfig.prefixLength;
    }];
  };
  networking.defaultGateway = networkConfig.gateway;
  networking.nameservers = networkConfig.nameservers;

  # Ensure networking service is enabled
  systemd.services."network-addresses-${hostCfg.interface}".enable = true;

  # Use 6.12 kernel for ZFS compatibility
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # ZFS configuration
  networking.hostId = hostCfg.hostId;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "mini-me-storage" ];

  # ZFS maintenance
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "monthly";
  services.zfs.autoScrub.pools = [ "mini-me-storage" ];

  # ZFS automatic snapshots
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 4; # Keep 4 15-minute snapshots
    hourly = 24; # Keep 24 hourly snapshots
    daily = 7; # Keep 7 daily snapshots
    weekly = 4; # Keep 4 weekly snapshots
    monthly = 12; # Keep 12 monthly snapshots
  };

  # Limit ZFS ARC to 6GB (tight RAM situation)
  boot.kernelParams = [ "zfs.zfs_arc_max=6442450944" ];

  # Fix ZFS mount timeouts during boot
  systemd.services.zfs-mount.enable = true;
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

  # Increase timeout for ZFS mounts
  systemd.services."zfs-mount".serviceConfig = { TimeoutStartSec = "5min"; };

  # Configure ZFS legacy mountpoints (prevents systemd mount race)
  # Set mountpoints after pool is imported
  systemd.services.zfs-set-mountpoints = {
    description = "Set ZFS legacy mountpoints for mini-me-storage pool";
    after = [ "zfs-import.target" ];
    before = [ "zfs-mount.service" ];
    wantedBy = [ "zfs-mount.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.zfs}/bin/zfs set mountpoint=/zfs/tank-replication mini-me-storage/tank-replication
      ${pkgs.zfs}/bin/zfs set mountpoint=/zfs/backups mini-me-storage/backups
    '';
  };
}
