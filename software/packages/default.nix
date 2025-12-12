{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.callPackage ./antigravity.nix { })
  ];
}
