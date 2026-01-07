{ pkgs, config, osConfig ? null, ... }:

{
  imports = [
    ./settings.nix
    ./style.nix
    ./mango-menu.nix
    ./toggle-waybar.nix
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = false;  # Waybar started manually via toggle-waybar or autostart

    # Powerline styling
    powerline = {
      enable = true;

      separators = {
        style = "triangle";
        inverted = false;
      };

      caps = {
        style = "inverted-triangle";
        inverted = true;
      };

      segment = {
        padding = "0 6px";
        margin = "2px 0";
        fontWeight = 600;
      };

      separator.size = 22;

      transitions = {
        enable = true;
        duration = "800ms";
        timing = "ease-in-out";
      };
    };
  };
}
