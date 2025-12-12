{ config, lib, pkgs, networkConfig, ... }:

let
  hostCfg = networkConfig.hosts.beelink;
in
{
  imports = [
    ./disko-config-stable.nix  # Stable by-id paths config
    ../../system/server
  ];

  networking.hostName = "beelink";
  networking.hostId = hostCfg.hostId;
  networking.networkmanager.enable = false;
  system.stateVersion = "25.11";


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

  # Use 6.17 kernel for servers
  boot.kernelPackages = pkgs.linuxPackages_6_17;

  # Override bootloader - servers use ext4, not btrfs subvolumes
  boot.loader.limine.extraConfig = lib.mkForce ''
    TIMEOUT=3
  '';

  # Kernel parameters for headless server - prevent GPU black screen
  boot.kernelParams = [
    # AMD GPU settings - let driver load but keep console active
    "amdgpu.dc=1"        # Enable Display Core
    "amdgpu.dpm=0"       # Disable dynamic power management
    "consoleblank=0"     # Disable console blanking
    # Console output for debugging
    "console=tty0"       # VGA console
    "loglevel=7"         # Verbose logging during boot
  ];

  # Disable Plymouth boot splash (can hide errors)
  boot.plymouth.enable = lib.mkForce false;

  # Enable early KMS for AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Ensure NVMe and disk modules are available in initrd
  boot.initrd.availableKernelModules = [
    "nvme"       # NVMe drive support
    "xhci_pci"   # USB 3.0
    "ahci"       # SATA
    "usbhid"     # USB HID devices
    "sd_mod"     # SCSI disk support
  ];
}
