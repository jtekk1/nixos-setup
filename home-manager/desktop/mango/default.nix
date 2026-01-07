{ pkgs, inputs, config, ... }:

{
  imports = [
    inputs.mangowc.hmModules.mango

    ./autostart.nix
    ./bindings
    ./config.nix
    ./env.nix
    ./looknfeel.nix
    ./monitors.nix
    ./windowrules.nix
    ./wlogout.nix
    ../common/waybar
  ];
}
