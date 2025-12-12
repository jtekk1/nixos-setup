{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gh
    git
    lazygit
    tea
  ];
}
