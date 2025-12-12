{ config, lib, pkgs, ... }:

let
  networkConfig = import ../../network-config.nix;
  hostCfg = networkConfig.hosts.deepspace;
in {
  imports = [
    ./hardware-configuration.nix
    ../../hardware
    ../../system/core
    ../../system/core/audio-n-wifi.nix # Audio (PipeWire) and WiFi (iwd) - desktop only
    ../../system/server/virtualization.nix
    ../../software/gaming/amd-support.nix # GPU-specific
  ];

  networking.hostName = "deepspace";

  # Static IP configuration
  networking.networkmanager.enable = false;
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
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable =
    false; # Using blueberry instead (configured in system/core/audio-n-wifi.nix)

  # Explicitly exclude blueman package and disable its autostart
  environment.etc."xdg/autostart/blueman.desktop".text = "";

  # Pin to 6.17 until xpadneo is fixed for 6.18+
  boot.kernelPackages = pkgs.linuxPackages_6_17;

  # Disable Bluetooth USB autosuspend to prevent ZSA keyboard disconnection issues
  boot.kernelParams = [ "btusb.enable_autosuspend=n" ];

  # Load required kernel modules:
  # - rtw89: Realtek WiFi driver for wireless network card
  # - kvm-amd: KVM virtualization support for AMD CPU
  boot.kernelModules = [ "rtw89" "kvm-amd" ];

  # Enable AppImage support and Cursor IDE
  programs.appimages = {
    enable = true;
    binfmt = true; # Allow direct execution of AppImages
    enableCursor = true; # Install Cursor v2.0.34 AppImage
  };
}

