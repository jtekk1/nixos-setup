{ config, lib, pkgs, inputs, ... }:

let
  networkConfig = import ../../network-config.nix;
in {
  imports = [
    ./hardware-configuration.nix
    ../../hardware/yubikey.nix
    ../../system/core
    ../../system/core/audio-n-wifi.nix # Audio (PipeWire) and WiFi (iwd) - desktop only
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
  ];

  networking.hostName = "thinkpad";

  # Use iwd for wifi (required for impala TUI)
  # NetworkManager conflicts with iwd standalone mode
  networking.networkmanager.enable = lib.mkForce false;
  networking.useDHCP = lib.mkForce true;
  networking.dhcpcd.enable = true;

  networking.nameservers = networkConfig.nameservers;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable =
    false; # Using bluetui instead (configured in system/core/audio-n-wifi.nix)

  # Explicitly exclude blueman package and disable its autostart
  environment.etc."xdg/autostart/blueman.desktop".text = "";

  # Pin to 6.17 until xpadneo is fixed for 6.18+
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  # Disable Bluetooth USB autosuspend to prevent ZSA keyboard disconnection issues
  boot.kernelParams = [ "btusb.enable_autosuspend=n" ];

  # Touchpad inputs
  services.libinput.enable = true;

  # ThinkPad-specific power management
  environment.systemPackages = with pkgs; [
    tpacpi-bat # ThinkPad battery threshold control
  ];

  # Enable AppImage support and Cursor IDE
  programs.appimages = {
    enable = true;
    binfmt = true; # Allow direct execution of AppImages
    enableCursor = true; # Install Cursor v2.0.34 AppImage
  };
}

