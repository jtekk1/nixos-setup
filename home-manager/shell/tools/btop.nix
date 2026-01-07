# Btop system monitor configuration with theme support
# Uses bg 1-3 and accent 1-3 from theme
{ config, pkgs, ... }:

let
  colors = config.theme.colors;
in
{
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;

    settings = {
      color_theme = "nix-theme";
      theme_background = false;
    };

    # Define custom theme using programs.btop.themes
    themes.nix-theme = ''
      # Dynamic theme from NixOS theme colors
      # bg: ${colors.bg_primary}, ${colors.bg_secondary}, ${colors.bg_tertiary}
      # accent: ${colors.accent_primary}, ${colors.accent_secondary}, ${colors.accent_tertiary}

      # Backgrounds
      theme[main_bg]="${colors.bg_primary}"
      theme[selected_bg]="${colors.bg_secondary}"
      theme[meter_bg]="${colors.bg_tertiary}"

      # Foregrounds
      theme[main_fg]="${colors.fg_primary}"
      theme[selected_fg]="${colors.fg_primary}"
      theme[inactive_fg]="${colors.fg_dim}"
      theme[graph_text]="${colors.fg_primary}"

      # UI accents
      theme[title]="${colors.accent_primary}"
      theme[hi_fg]="${colors.accent_secondary}"
      theme[proc_misc]="${colors.accent_tertiary}"

      # Box borders
      theme[cpu_box]="${colors.accent_primary}"
      theme[mem_box]="${colors.accent_secondary}"
      theme[net_box]="${colors.accent_tertiary}"
      theme[proc_box]="${colors.accent_primary}"
      theme[div_line]="${colors.accent_primary}"

      # CPU gradient: tertiary -> secondary -> primary
      theme[cpu_start]="${colors.accent_tertiary}"
      theme[cpu_mid]="${colors.accent_secondary}"
      theme[cpu_end]="${colors.accent_primary}"

      # Temperature gradient
      theme[temp_start]="${colors.accent_tertiary}"
      theme[temp_mid]="${colors.accent_secondary}"
      theme[temp_end]="${colors.accent_primary}"

      # Memory gradients
      theme[free_start]="${colors.accent_tertiary}"
      theme[free_mid]="${colors.accent_secondary}"
      theme[free_end]="${colors.accent_primary}"
      theme[cached_start]="${colors.accent_tertiary}"
      theme[cached_mid]="${colors.accent_secondary}"
      theme[cached_end]="${colors.accent_primary}"
      theme[available_start]="${colors.accent_tertiary}"
      theme[available_mid]="${colors.accent_secondary}"
      theme[available_end]="${colors.accent_primary}"
      theme[used_start]="${colors.accent_tertiary}"
      theme[used_mid]="${colors.accent_secondary}"
      theme[used_end]="${colors.accent_primary}"

      # Network gradients
      theme[download_start]="${colors.accent_tertiary}"
      theme[download_mid]="${colors.accent_secondary}"
      theme[download_end]="${colors.accent_primary}"
      theme[upload_start]="${colors.accent_tertiary}"
      theme[upload_mid]="${colors.accent_secondary}"
      theme[upload_end]="${colors.accent_primary}"

      # Process gradient
      theme[process_start]="${colors.accent_tertiary}"
      theme[process_mid]="${colors.accent_secondary}"
      theme[process_end]="${colors.accent_primary}"
    '';
  };
}