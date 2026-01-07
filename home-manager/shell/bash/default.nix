{ ... }:

{
  imports = [
    ./aliases.nix
    ./initx.nix
    ./paths.nix
    ./readline.nix
    ./variables.nix
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}
