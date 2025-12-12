{ pkgs, inputs, config, ... }:

{
  imports = [
    # Import the Mango WM home-manager module
    inputs.mangowc.hmModules.mango

    # Import configuration modules
    ./autostart.nix
    ./bindings
    ./config.nix
    ./env.nix
    ./looknfeel.nix
    ./monitors.nix
    # ./waybar.nix  # Disabled
    ./windowrules.nix
    # ./wlogout.nix  # Replaced by wofi power menu
  ];
}
