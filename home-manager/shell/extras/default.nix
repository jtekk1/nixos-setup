{ pkgs, ... }:

{
  # Fun terminal screensavers and animations
  home.packages = with pkgs; [
    asciiquarium # ASCII aquarium animation
    cmatrix # Matrix rain animation
    pipes-rs # Pipes screensaver (Rust rewrite of pipes.sh)
  ];
}
