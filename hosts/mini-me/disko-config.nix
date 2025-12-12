# Disko configuration for Mini-me
# Hardware:
# - nvme2n1: 953.9GB (1TB) - System disk
# - 4x 3.6TB NVMe drives - All for Longhorn distributed storage

{ lib, ... }:
{
  disko.devices = {
    disk = {
      # System disk - 1TB NVMe
      system = {
        type = "disk";
        device = "/dev/nvme2n1";
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

      # Storage disks for Longhorn - 4x 4TB NVMe
      # Each disk mounted separately for Longhorn to manage
      storage1 = {
        type = "disk";
        device = "/dev/nvme0n1";  # Adjust based on actual device names
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/disk1";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      storage2 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/disk2";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      storage3 = {
        type = "disk";
        device = "/dev/nvme3n1";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/disk3";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      storage4 = {
        type = "disk";
        device = "/dev/nvme4n1";
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn/disk4";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}