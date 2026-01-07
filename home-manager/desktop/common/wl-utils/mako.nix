{ pkgs, config, ... }:

{
  # Replace your entire services.mako block with this one.
  # This version uses the new 'settings' structure and is the correct
  # approach for modern Home Manager versions.
  services.mako = {
    enable = true;
    settings = {
      # --- Global Settings ---
      # Note: We use the original TOML names now, like "border-size"
      sort = "-time";
      layer = "overlay";
      "max-visible" = 5;
      anchor = "top-center";
      font = "JetBrainsMono Nerd Font 11";
      width = 500;  # Increased from 350 to show more text
      height = 200; # Increased from 110 to allow for more lines
      margin = 10;
      padding = 15;
      "border-size" = 2;
      "border-radius" = 0;
      icons = 1; # Use 1/0 for booleans as in the original file
      "max-icon-size" = 64;
      markup = 1;
      actions = 1;
      history = 1;
      "max-history" = 100;
      "default-timeout" = 10000;  # Increased to 10 seconds for better readability
      "ignore-timeout" = 0;
      "group-by" = "app-name";
      "background-color" = "${config.theme.colors.bg_primary}F2";
      "text-color" = "${config.theme.colors.fg_primary}";
      "border-color" = "${config.theme.colors.accent_primary}";
      "progress-color" = "over ${config.theme.colors.accent_secondary}";
      "icon-location" = "left";
      "text-alignment" = "left";

      # --- Conditional Sections ---
      # Each TOML section header [like-this] becomes an attribute set.
      "urgency=low" = {
        "border-color" = "${config.theme.colors.border_inactive}";
        "background-color" = "${config.theme.colors.bg_primary}F2";
        "text-color" = "${config.theme.colors.fg_dim}";
        "default-timeout" = 3000;
      };

      "urgency=normal" = {
        "border-color" = "${config.theme.colors.accent_primary}";
        "background-color" = "${config.theme.colors.bg_primary}F2";
        "text-color" = "${config.theme.colors.fg_primary}";
        "default-timeout" = 5000;
      };

      "urgency=high" = {
        "border-color" = "${config.theme.colors.accent_tertiary}";
        "background-color" = "${config.theme.colors.accent_tertiary}F2";
        "text-color" = "${config.theme.colors.bg_primary}";
        "default-timeout" = 0;
      };

      grouped = {
        format = ''<b>%s</b>\n%b'';
      };
    };
  };
}
