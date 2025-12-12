# Disko configuration for Beelink
# Hardware:
# - nvme1n1: 931.5GB (1TB) - System disk
# - nvme0n1: 3.6TB (4TB) - Storage disk for Longhorn

{ lib, ... }:
{
  disko.devices = {
    disk = {
      # System disk - 1TB NVMe (931.5GB)
      system = {
        type = "disk";
        device = "/dev/nvme1n1";  # 931.5GB system disk
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

      # Storage disk - 4TB NVMe for Longhorn
      storage = {
        type = "disk";
        device = "/dev/nvme0n1";  # 3.6TB storage disk
        content = {
          type = "gpt";
          partitions = {
            longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}