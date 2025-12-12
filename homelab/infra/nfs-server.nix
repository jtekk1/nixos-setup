{ config, lib, pkgs, ... }:

{
  # NFS Server - Export backups directory to homelab
  # Only runs on tank

  services.nfs.server = {
    enable = true;

    # NFS exports
    exports = ''
      # Export backups directory to homelab hosts (on ZFS pool)
      /zfs/backups 192.168.0.250(rw,sync,no_subtree_check,no_root_squash) 192.168.0.251(rw,sync,no_subtree_check,no_root_squash)
    '';
  };

  # Open firewall for NFS
  networking.firewall = {
    allowedTCPPorts = [
      111   # rpcbind
      2049  # nfsd
      20048 # mountd
    ];
    allowedUDPPorts = [
      111   # rpcbind
      2049  # nfsd
      20048 # mountd
    ];
  };
}
