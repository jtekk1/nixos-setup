{ pkgs, inputs, config, ... }:

{
  imports = [
    ./3pd.nix
    ./apps.nix
    ./core.nix
    ./layout.nix
    ./media.nix
    ./windows.nix
  ];
}
