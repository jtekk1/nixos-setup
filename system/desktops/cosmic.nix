{ pkgs, ... }:

let customIcons = pkgs.callPackage ../../home/assets/icons { };

in {
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    customIcons
    papirus-icon-theme
    cosmic-store
  ];
}
