{ pkgs, ... }:

{
  imports = [
    ./foot.nix
    ./kitty.nix
    ./alacritty.nix
    ./ghostty.nix
    ./zellij.nix
    ./webapps.nix
    ./nixvim.nix
  ];
}
