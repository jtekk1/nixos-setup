# Btop system monitor configuration with theme support
{ config, pkgs, ... }:

let
  colors = config.theme.colors;
in
{
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      # This is CRUCIAL. It forces btop to use the custom theme[] values below.
      color_theme = "unsupported";
      theme_background = false;

      # Dynamic theme settings based on current theme
      "theme[main_bg]" = colors.bg_primary;
      "theme[main_fg]" = colors.fg_primary;
      "theme[title]" = colors.accent_primary;
      "theme[hi_fg]" = colors.accent_tertiary;
      "theme[selected_bg]" = colors.bg_tertiary;
      "theme[selected_fg]" = colors.fg_primary;
      "theme[inactive_fg]" = colors.fg_dim;
      "theme[graph_text]" = colors.fg_primary;
      "theme[meter_bg]" = colors.bg_tertiary;
      "theme[proc_misc]" = colors.color5;
      "theme[cpu_box]" = colors.accent_primary;
      "theme[cpu_core]" = colors.fg_primary;
      "theme[cpu_graph_low]" = colors.accent_tertiary;
      "theme[cpu_graph_mid]" = colors.accent_secondary;
      "theme[cpu_graph_high]" = colors.accent_primary;
      "theme[mem_box]" = colors.accent_primary;
      "theme[mem_graph_low]" = colors.bg_tertiary;
      "theme[mem_graph_mid]" = colors.accent_primary;
      "theme[mem_graph_high]" = colors.accent_secondary;
      "theme[net_box]" = colors.accent_primary;
      "theme[net_text]" = colors.fg_primary;
      "theme[net_graph_low]" = colors.bg_tertiary;
      "theme[net_graph_mid]" = colors.accent_primary;
      "theme[net_graph_high]" = colors.accent_secondary;
      "theme[download_start]" = colors.accent_tertiary;
      "theme[download_mid]" = colors.accent_secondary;
      "theme[download_end]" = colors.accent_primary;
      "theme[upload_start]" = colors.bg_tertiary;
      "theme[upload_mid]" = colors.accent_primary;
      "theme[upload_end]" = colors.accent_secondary;
      "theme[proc_box]" = colors.accent_primary;
      "theme[proc_cpu_low]" = colors.accent_tertiary;
      "theme[proc_cpu_mid]" = colors.accent_secondary;
      "theme[proc_cpu_high]" = colors.accent_primary;
      "theme[proc_mem_low]" = colors.bg_tertiary;
      "theme[proc_mem_mid]" = colors.accent_primary;
      "theme[proc_mem_high]" = colors.accent_secondary;
      "theme[temp_start]" = colors.accent_tertiary;
      "theme[temp_mid]" = colors.accent_secondary;
      "theme[temp_end]" = colors.accent_primary;
      "theme[battery_start]" = colors.accent_tertiary;
      "theme[battery_mid]" = colors.accent_secondary;
      "theme[battery_end]" = colors.accent_primary;
      "theme[clock]" = colors.color5;
      "theme[input_bg]" = colors.bg_primary;
      "theme[input_fg]" = colors.fg_primary;
      "theme[border]" = colors.accent_primary;
      "theme[border_secondary]" = colors.accent_secondary;
    };
  };
}