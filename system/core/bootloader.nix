{ config, lib, pkgs, ... }:

let limineWallpaper = ../../home/assets/backgrounds/1.png;
in {
  boot.loader.limine = {
    enable = true;
    # Limine bootloader styling
    style = {
      wallpapers = [ limineWallpaper ];
      wallpaperStyle = "centered";
    };
    extraConfig = ''
      TIMEOUT=0
      LINUX_CMDLINE_LINUX="rootflags=subvol=@root"
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

}
