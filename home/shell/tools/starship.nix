# Starship prompt configuration with theme support
{ config, pkgs, ... }:

let colors = config.theme.colors;
in {
  programs.starship = {
    enable = true;
    # The settings block directly mirrors your starship.toml file
    settings = {
      add_newline = true;

      # The main format string for the prompt with proper powerline flow
      # Original color flow: #333066 -> #8B008B -> #DD00FF -> #00FFFF -> #FFD700 -> #FF00FF
      # Maps to: bg_tertiary -> bg_secondary -> accent_primary -> accent_secondary -> accent_tertiary -> back to accent_primary
      format = ''
        [](fg:${colors.accent_primary})$username$hostname[](bg:${colors.accent_secondary} fg:${colors.accent_primary})$container$nix_shell[](bg:${colors.accent_tertiary} fg:${colors.accent_secondary})$directory[](bg:${colors.accent_primary} fg:${colors.accent_tertiary})$git_branch$git_status[](bg:${colors.accent_secondary} fg:${colors.accent_primary})$golang$java$nodejs$rust$python[](bg:${colors.accent_tertiary} fg:${colors.accent_secondary})$time[](fg:${colors.accent_tertiary})
        $character'';

      # Character symbols for prompt
      character = {
        success_symbol =
          "[󰁔](bold fg:${colors.accent_tertiary})"; # Rich Gold equivalent
        error_symbol = "[](bold fg:${colors.color1})"; # Red/Error color
        vicmd_symbol =
          "[◀](bold fg:${colors.accent_secondary})"; # Electric Blue/Cyan equivalent
      };

      username = {
        show_always = true;
        style_user = "bg:${colors.accent_primary} fg:${colors.bg_primary}";
        style_root = "bg:${colors.accent_primary} fg:${colors.bg_primary}";
        format = "[ $user]($style)";
      };

      hostname = {
        ssh_only = false;
        ssh_symbol = "";
        style = "bg:${colors.accent_primary} fg:${colors.bg_primary}";
        format = "[@$hostname $ssh_symbol]($style)";
      };

      directory = {
        style = "bg:${colors.accent_tertiary} fg:${colors.bg_primary}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        # Nested tables like [directory.substitutions] become nested attribute sets
        substitutions = {
          "~" = "󰋜";
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "Desktop" = "󰀾 ";
          "Videos" = "󰕧 ";
          "Public" = "󰐕 ";
          "Templates" = "󰏗 ";
          "NixSetups" = " ";
        };
      };

      git_branch = {
        symbol = "󰘬";
        style = "bg:${colors.accent_primary} fg:${colors.bg_primary}";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:${colors.accent_primary} fg:${colors.bg_primary}";
        format = "[$all_status$ahead_behind ]($style)";
      };

      nodejs = {
        symbol = "󰌞󰛦";
        style = "bg:${colors.accent_secondary} fg:${colors.bg_primary}";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "󱘗 ";
        style = "bg:${colors.accent_secondary} fg:${colors.bg_primary}";
        format = "[ $symbol ($version) ]($style)";
      };

      golang = {
        symbol = "󰟓 ";
        style = "bg:${colors.accent_secondary} fg:${colors.bg_primary}";
        format = "[ $symbol ($version) ]($style)";
      };

      python = {
        version_format = "\${raw}"; # The extra '' escape the Nix interpolation
        symbol = " 🐍 ";
        style = "bg:${colors.accent_secondary} fg:${colors.bg_primary}";
        format = "[\${symbol}\${version} ]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:${colors.accent_secondary} fg:${colors.bg_primary}";
        format = "[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:${colors.accent_tertiary} fg:${colors.bg_primary}";
        format = "[ $symbol $context ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:${colors.accent_tertiary} fg:${colors.bg_primary}";
        format = "[ 󰅐 $time ]($style)";
      };

      container = {
        style = "bg:${colors.accent_secondary} fg:${colors.bg_primary}";
        format = "[ ⬢ $name ]($style)";
      };

      nix_shell = {
        symbol = " ";
        style = "bg:${colors.accent_secondary} fg:${colors.bg_primary}";
        format = "[ $symbol $name ]($style)";
        heuristic = true;
      };
    };
  };
}
