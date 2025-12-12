{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    heroic-unwrapped
    umu-launcher
  ];

}
