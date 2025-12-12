{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.jtekk.software.openrgb.enable {
    # Enable the OpenRGB service - CRITICAL for proper device detection
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";  # Set to AMD for Gigabyte AM4/AM5 boards
      package = pkgs.openrgb-with-all-plugins-git;  # Use git version for B850 chipset support
    };

    # Enable system-wide I2C support - REQUIRED for motherboard RGB
    hardware.i2c.enable = true;

    # Kernel parameters for better I2C/SMBus access
    boot.kernelParams = [
      "acpi_enforce_resources=lax"  # Allow access to SMBus resources
    ];

    # Load necessary kernel modules for I2C and RGB detection
    boot.kernelModules = [
      # Core I2C modules
      "i2c-dev"       # I2C device interface - required for all I2C devices
      "i2c-piix4"     # AMD SMBus driver - essential for AMD chipsets

      # Gigabyte-specific modules
      "it87"          # ITE Super I/O chips (common on Gigabyte boards)
      "nct6775"       # Nuvoton Super I/O chips (alternative Gigabyte sensor chip)

      # DDR5 RGB RAM modules - G.Skill Trident Z5
      "ee1004"        # SPD/EEPROM access for DDR4/DDR5 RGB RAM
      "i2c-mux"       # I2C multiplexer support for DDR5
      "at24"          # Additional EEPROM support
      "spd5118"       # DDR5 SPD Hub support (kernel 6.11+)
    ];

    # Install OpenRGB and diagnostic tools
    environment.systemPackages = with pkgs; [
      # Wrapper for OpenRGB with proper Qt theming
      (pkgs.writeShellScriptBin "openrgb" ''
        export QT_STYLE_OVERRIDE=Fusion
        exec ${pkgs.openrgb-with-all-plugins-git}/bin/openrgb "$@"
      '')

      i2c-tools                      # I2C debugging utilities (i2cdetect, i2cdump)
      ddcutil                        # Additional I2C diagnostic tool

      # Qt5 compatibility packages
      libsForQt5.qtstyleplugins
      qt5.qtwayland
      adwaita-qt
    ];

    # Create i2c group and add user to it
    users.groups.i2c = {};

    # Add user to necessary groups for hardware access
    users.users.jtekk.extraGroups = [ "i2c" ];

    # Comprehensive udev rules for RGB device access
    services.udev.extraRules = ''
      # I2C device access rules - allow i2c group full access
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"

      # Gigabyte RGB devices (USB vendor ID: 0x1044)
      SUBSYSTEM=="usb", ATTR{idVendor}=="1044", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1044", MODE="0666"

      # Corsair devices (RAM, peripherals)
      SUBSYSTEM=="usb", ATTR{idVendor}=="1b1c", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", MODE="0666"

      # ASUS devices (motherboards, GPUs)
      SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0b05", MODE="0666"

      # MSI devices
      SUBSYSTEM=="usb", ATTR{idVendor}=="1462", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1462", MODE="0666"

      # Razer devices (peripherals)
      SUBSYSTEM=="usb", ATTR{idVendor}=="1532", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1532", MODE="0666"

      # Logitech devices
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0666"

      # G.Skill RAM
      SUBSYSTEM=="usb", ATTR{idVendor}=="195d", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="195d", MODE="0666"

      # NVIDIA GPUs (USB RGB control)
      SUBSYSTEM=="usb", ATTR{idVendor}=="10de", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="10de", MODE="0666"

      # AMD GPUs (USB RGB control)
      SUBSYSTEM=="usb", ATTR{idVendor}=="1002", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1002", MODE="0666"

      # ITE Tech RGB controller chips (Gigabyte B850 AORUS uses 048d:5711)
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="048d", MODE="0666"
      # Specific rule for Gigabyte B850 AORUS STEALTH ICE
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="5711", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="048d", ATTRS{idProduct}=="5711", MODE="0666"
    '';

    # Optional: Enable OpenRGB server mode (uncomment if you want network control)
    # systemd.services.openrgb = {
    #   description = "OpenRGB Server";
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "network.target" ];
    #   serviceConfig = {
    #     Type = "simple";
    #     User = "jtekk";
    #     ExecStart = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --server --server-port 6742";
    #     Restart = "on-failure";
    #     RestartSec = "5s";
    #   };
    # };
  };
}
