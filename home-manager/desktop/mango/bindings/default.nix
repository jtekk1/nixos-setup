{ pkgs, inputs, config, ... }:

{
  imports = [
    ./3pd.nix
    ./apps.nix
    ./core.nix
    ./input.nix
    ./layout.nix
    ./media.nix
    ./windows.nix
  ];
}
