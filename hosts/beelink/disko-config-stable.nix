# Disko configuration for Beelink - Stable paths
# Purpose: Gateway server with simple ext4 setup
# Hardware (using stable /dev/disk/by-id paths):
# - CT1000P3PSSD8 931.5GB (nvme1n1): System disk
# - Samsung 990 EVO Plus 4TB (nvme0n1): Storage disk

{ ... }:
{
  disko.devices = {
    disk = {
      # System disk
      system = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_25114EE276F9";
        content = {
          type = "gpt";
          partitions = {
            # EFI boot partition
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0022" "dmask=0022" ];
                extraArgs = [ "-n" "NIXOS_EFI" ];
              };
            };
            # Root partition
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

      # Storage disk
      storage = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y706591T";
        content = {
          type = "gpt";
          partitions = {
            storage = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/mnt/storage";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
