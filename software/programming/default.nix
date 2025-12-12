{ config, ... }:

{
  imports = [
    ./ollama.nix
    ./containers.nix
    ./dev.nix
    ./editors.nix
    ./git.nix
  ];
}
