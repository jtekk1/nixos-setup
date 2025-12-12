{ config, pkgs, ... }:

let
  networkConfig = import ../../network-config.nix;
in
{
  # NFS Server Configuration
  services.nfs.server = {
    enable = true;
    # Export ZFS datasets
    exports = ''
      # Syntax: path client(options)
      # Adjust paths based on your ZFS datasets

      # Read-write access from local network - no authentication required
      /storage/nas/media      ${networkConfig.lan}(rw,sync,no_subtree_check,all_squash,anonuid=65534,anongid=65534)
      /storage/nas/documents  ${networkConfig.lan}(rw,sync,no_subtree_check,all_squash,anonuid=65534,anongid=65534)
      /storage/nas/backups    ${networkConfig.lan}(rw,sync,no_subtree_check,all_squash,anonuid=65534,anongid=65534)
    '';

    # Fixed NFS ports for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
  };

  # SMB/CIFS Server Configuration (Samba)
  services.samba = {
    enable = true;
    openFirewall = true;

    # Use new settings format - all configuration now goes under settings
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "${config.networking.hostName} NAS";
        "netbios name" = config.networking.hostName;
        security = "user";  # Using the new location for security setting
        "map to guest" = "Bad User";
        "guest account" = "nobody";

        # Performance tuning
        "socket options" = "TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192";
        "min receivefile size" = 16384;
        "write cache size" = 262144;

        # Better macOS compatibility
        "vfs objects" = "fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
      };

      # Shares now go under settings, not as a separate attribute
      media = {
        path = "/storage/nas/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";  # Allow guest access
        "force user" = "nobody";
        "force group" = "nogroup";
        "create mask" = "0664";
        "directory mask" = "0775";
        comment = "Media Files";
      };

      documents = {
        path = "/storage/nas/documents";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";  # Allow guest access
        "force user" = "nobody";
        "force group" = "nogroup";
        "create mask" = "0664";
        "directory mask" = "0775";
        comment = "Documents";
      };

      backups = {
        path = "/storage/nas/backups";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";  # Allow guest access
        "force user" = "nobody";
        "force group" = "nogroup";
        "create mask" = "0664";
        "directory mask" = "0775";
        comment = "Backup Storage";
      };

      # Time Machine support for macOS
      timemachine = {
        path = "/storage/nas/timemachine";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";  # Allow guest access
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        comment = "Time Machine Backups";
      };
    };
  };

  # No password needed - guest access is enabled for all shares
  # Anyone on the local network can access the shares

  # Avahi for network discovery (makes shares visible in network browsers)
  services.avahi = {
    enable = true;
    nssmdns4 = true;  # Updated from nssmdns to nssmdns4
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };

  # Open firewall ports
  networking.firewall = {
    allowedTCPPorts = [
      111   # NFS portmapper
      2049  # NFS
      4000  # NFS statd
      4001  # NFS lockd
      4002  # NFS mountd
      445   # SMB
      139   # NetBIOS
    ];
    allowedUDPPorts = [
      111   # NFS portmapper
      2049  # NFS
      4000  # NFS statd
      4001  # NFS lockd
      4002  # NFS mountd
      137   # NetBIOS
      138   # NetBIOS
    ];
  };

  # Install client tools
  environment.systemPackages = with pkgs; [
    nfs-utils
    samba
    cifs-utils
  ];
}