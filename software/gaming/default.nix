{ config, ... }:

{
  imports = [
    ./deps.nix
    ./others.nix
    ./steam.nix
    ./tools.nix
  ];
}
