# Disko configuration for Tank
# Hardware:
# - nvme1n1: 119.2GB - System disk (SMALL!)
# - nvme0n1, nvme2n1: 3.6TB each - Fast storage tier
# - sda, sdc, sdd, sde, sdf: 18.2TB HDDs - Bulk storage tier
# NOTE: sdb is often the USB installer, so we skip it!

{ lib, ... }:
{
  disko.devices = {
    disk = {
      # System disk - 120GB NVMe (tight!)
      system = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-AirDisk_128GB_SSD_QES481B000450P110N";  # 119.2GB system disk
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";  # ~118GB for system
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };

      # Fast tier - 2x 3.6TB NVMe for Longhorn
      fast1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250D1F319";  # First 3.6TB NVMe
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/fast1";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      fast2 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250F532B6";  # Second 3.6TB NVMe
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/fast2";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      # Bulk tier - 5x 18.2TB HDDs for Longhorn (using stable by-id paths)
      bulk1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9JBA5";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/bulk1";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      bulk2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9GT8T";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/bulk2";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      bulk3 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9CDLV";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/bulk3";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      bulk4 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD8NNDT";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/bulk4";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      bulk5 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9L6LS";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/bulk5";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}