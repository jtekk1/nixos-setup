{ pkgs, ... }:

{
  imports = [
    ./aliases.nix
    ./initx.nix
    ./paths.nix
    ./readline.nix
    ./variables.nix
  ];

  home.packages = [ pkgs.blesh ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}
