{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clip-persist  # Keep clipboard after app closes
    wl-clipboard     # Wayland clipboard utilities
    cliphist         # Clipboard history manager
  ];
}
