{ config, lib, pkgs, ... }:

{
  # NFS Client - Mount tank's backups directory
  # Runs on beelink and mini-me

  # Mount tank's NFS export
  fileSystems."/mnt/tank-backups" = {
    device = "192.168.0.252:/zfs/backups";
    fsType = "nfs";
    options = [
      "x-systemd.automount"  # Auto-mount on access
      "noauto"               # Don't mount at boot
      "x-systemd.idle-timeout=600"  # Unmount after 10 min idle
    ];
  };

  # Ensure mount point exists
  systemd.tmpfiles.rules = [
    "d /mnt/tank-backups 0755 root root -"
  ];
}
