# Disko configuration for Mini-me - ZFS Production
# Purpose: Secondary storage and replication target
# Hardware (using stable /dev/disk/by-id paths):
# - Inland 953.9GB (nvme2n1): System disk (keep ext4)
# - CT4000P310SSD8 x4 (nvme0n1, nvme1n1, nvme3n1, nvme4n1): 3.6TB each - ZFS raidz1

{ ... }:
{
  disko.devices = {
    disk = {
      # System disk - keep ext4
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Inland_TN320_NVMe_SSD_IB25ADE0001P00032";
        content = {
          type = "gpt";
          partitions = {
            # EFI boot partition
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0022" "dmask=0022" ];
                extraArgs = [ "-n" "NIXOS_EFI" ];
              };
            };
            # Main system partition
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };

    # ZFS pool - raidz1 of 4x 3.6TB NVMe drives
    zpool = {
      mini-me-storage = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          compression = "zstd";
          atime = "off";
          xattr = "sa";
          acltype = "posixacl";
        };
        options = {
          ashift = "12";  # 4K sectors
          autotrim = "on";
        };

        datasets = {
          # Use null mountpoint to prevent systemd mount race
          # Tank replication target
          "tank-replication" = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              recordsize = "128k";  # Mixed workload from tank
            };
          };

          # Backup storage
          "backups" = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              recordsize = "1M";  # Large backup files
            };
          };
        };
      };
    };

    # Disks for mini-me-storage pool (raidz1)
    disk.storage1 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250D1F898";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "mini-me-storage";
            };
          };
        };
      };
    };

    disk.storage2 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250F532C0";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "mini-me-storage";
            };
          };
        };
      };
    };

    disk.storage3 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250D20748";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "mini-me-storage";
            };
          };
        };
      };
    };

    disk.storage4 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250F52FFF";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "mini-me-storage";
            };
          };
        };
      };
    };
  };
}
