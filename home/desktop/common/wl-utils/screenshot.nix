{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grim      # Screenshot utility
    slurp     # Region selection
    shotman   # Screenshot GUI
    swappy    # Screenshot annotation
    hyprshot  # Hyprland screenshot wrapper
  ];
}
