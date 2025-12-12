{ pkgs, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    withUWSM = true;
  };

  # Hyprland ecosystem packages
  environment.systemPackages = with pkgs; [
    hypridle
    hyprland-qtutils
    hyprlock
    hyprcursor
  ];
}
