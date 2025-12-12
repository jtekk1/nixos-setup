# Disko configuration for Tank - ZFS Production
# Purpose: Production ZFS deployment with fast + bulk tiers
# Hardware (using stable /dev/disk/by-id paths to prevent device name shuffling):
# - AirDisk 128GB (nvme0n1): System disk (keep BTRFS)
# - CT4000P310SSD8 x2 (nvme1n1, nvme2n1): 3.6TB each - Fast tier (ZFS mirror)
# - ST20000NT001 x5 (sda-sde): 18.2TB each - Bulk tier (ZFS raidz1)

{ ... }:
{
  disko.devices = {
    disk = {
      # Main NVMe system disk - keep BTRFS
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-AirDisk_128GB_SSD_QES481B000450P110N";
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
            # Main system partition with BTRFS subvolumes
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-L" "NIXOS_ROOT" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "discard=async" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "discard=async" "noatime" ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "discard=async" "noatime" ];
                  };
                  "@swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "nodatacow" ];
                    swap = {
                      swapfile = {
                        size = "8G";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };

    # ZFS pools
    zpool = {
      # Fast tier - Mirror of 2x 3.6TB NVMe drives
      tank-fast = {
        type = "zpool";
        mode = "mirror";
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
          # Gitea - PostgreSQL database
          # Use null mountpoint to prevent systemd mount race
          "gitea" = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              recordsize = "16k";  # Optimized for PostgreSQL
            };
          };
        };
      };

      # Bulk tier - RAIDZ1 of 5x 18.2TB HDDs
      tank-bulk = {
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
          # Nextcloud - large files
          "nextcloud" = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              recordsize = "1M";  # Large files
            };
          };

          # Immich - photos and videos
          "immich" = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              recordsize = "1M";  # Large media files
            };
          };

          # Paperless - documents
          "paperless" = {
            type = "zfs_fs";
            mountpoint = null;
            options = {
              recordsize = "128k";  # Medium-sized documents
            };
          };

          # Backups - mixed workload
          "backups" = {
            type = "zfs_fs";
            mountpoint = null;
            # Use default recordsize (128k inherited from pool)
          };
        };
      };
    };

    # Disks for tank-fast pool (mirror)
    disk.fast1 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250D1F319";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank-fast";
            };
          };
        };
      };
    };

    disk.fast2 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000P310SSD8_252250F532B6";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank-fast";
            };
          };
        };
      };
    };

    # Disks for tank-bulk pool (raidz1)
    disk.bulk1 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9JBA5";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank-bulk";
            };
          };
        };
      };
    };

    disk.bulk2 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9CDLV";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank-bulk";
            };
          };
        };
      };
    };

    disk.bulk3 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD8NNDT";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank-bulk";
            };
          };
        };
      };
    };

    disk.bulk4 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9GT8T";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank-bulk";
            };
          };
        };
      };
    };

    disk.bulk5 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST20000NT001-3MB101_ZYD9L6LS";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank-bulk";
            };
          };
        };
      };
    };
  };

  # Additional filesystem configuration
  fileSystems."/var/log".neededForBoot = true;
}
