{ pkgs, lib, config, ... }:

let
  colors = config.theme.colors;
  pl = config.programs.waybar.powerline;

  # Theme colors with fallbacks
  primaryColor = if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null
                 then colors.mangoOverrides.focuscolor
                 else colors.accent_primary;
  urgentColor = if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null
                then colors.mangoOverrides.urgentcolor
                else colors.accent_secondary;

  # Separator characters
  separatorChars = {
    half-circle = { right = ""; left = ""; };
    triangle = { right = ""; left = ""; };
    inverted-triangle = { right = ""; left = ""; };
    bot-triangle = { right = ""; left = ""; };
    top-triangle = { right = ""; left = ""; };
  };

  # Get separator characters based on config
  sepStyle = separatorChars.${pl.separators.style};
  tailStyle = separatorChars.${pl.tails.style};

  # Handle inversion
  sepRight = if pl.separators.inverted then sepStyle.left else sepStyle.right;
  sepLeft = if pl.separators.inverted then sepStyle.right else sepStyle.left;
  tailRight = if pl.tails.inverted then tailStyle.left else tailStyle.right;
  tailLeft = if pl.tails.inverted then tailStyle.right else tailStyle.left;

  # Color cycling for modules (primary -> secondary -> tertiary)
  accentColors = [
    colors.accent_primary
    colors.accent_secondary
    colors.accent_tertiary
  ];

  # Base style (non-powerline)
  baseStyle = ''
    * {
      font-family: CaskaydiaCove Nerd Font Propo, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
      font-size: 11px;
    }

    window#waybar {
      background-color: ${colors.rgba.bg_primary 1.0};
      border-bottom: 2px solid ${primaryColor};
    }

    #workspaces,
    #workspaces button {
      background: transparent;
      border: 0;
      border-radius: 20px;
      opacity: 1.0;
      padding: 0 2px;
      box-shadow: none;
      border: none;
      outline: none;
      text-shadow: none;
      animation: none;
      color: ${colors.fg_dim};
    }

    #workspaces button.hidden {
      opacity: 0.2;
    }

    #workspaces button.active {
      transition: ease-in 300ms;
      opacity: 1.0;
      color: ${primaryColor};
    }

    #workspaces button.urgent {
      background-color: ${urgentColor};
    }

    #window,
    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #network,
    #pulseaudio,
    #bluetooth,
    #custom-power,
    #custom-monitor-toggle,
    #custom-weather,
    #custom-date,
    #tray {
      padding: 0 10px;
      color: ${primaryColor};
      border-right: 1px solid rgba(255,255,255,0.2);
    }

    #clock {
      border-right: none;
    }

    #bluetooth.connected {
      color: ${colors.accent_secondary};
    }

    #bluetooth.off,
    #bluetooth.disabled {
      color: ${colors.fg_dim};
    }

    #battery.charging {
      color: #ffffff;
      background-color: ${primaryColor};
    }

    #pulseaudio:hover {
      background-color: ${primaryColor};
    }
  '';

  # Powerline style
  powerlineStyle = ''
    * {
      font-family: CaskaydiaCove Nerd Font Propo, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
      font-size: 11px;
      border: none;
      border-radius: 0;
    }

    window#waybar {
      background-color: ${colors.rgba.bg_primary 0.15};
      border: none;
    }

    /* Segment base styling */
    .modules-left > widget > *,
    .modules-right > widget > * {
      padding: ${pl.segment.padding};
      margin: ${pl.segment.margin};
      font-weight: ${toString pl.segment.fontWeight};
      ${if pl.transitions.enable then ''
      transition: all ${pl.transitions.duration} ${pl.transitions.timing};
      '' else ""}
    }

    /* === LEFT MODULES (powerline going right →) === */

    /* Power - accent_primary */
    #custom-power {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
      padding-left: 12px;
    }

    /* CPU - accent_secondary */
    #cpu {
      background-color: ${colors.accent_secondary};
      color: ${colors.bg_secondary};
    }

    /* Memory - accent_tertiary */
    #memory {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    /* Disk - accent_primary */
    #disk {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
    }

    /* Network - accent_secondary */
    #network {
      background-color: ${colors.accent_secondary};
      color: ${colors.bg_secondary};
    }

    /* Window/Layout - accent_tertiary */
    #window {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    /* Monitor toggle - accent_primary */
    #custom-monitor-toggle {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
      padding-right: 12px;
    }

    /* === CENTER MODULES === */

    #workspaces {
      background: transparent;
      margin: 2px 0;
    }

    #workspaces button {
      background-color: ${colors.accent_secondary};
      color: ${colors.bg_secondary};
      opacity: 0.35;
      padding: 0 8px;
      margin: 0 2px;
      border-radius: 0;
    }

    #workspaces button.hidden {
      opacity: 0.95;
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    #workspaces button.active {
      opacity: 1.0;
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
    }

    #workspaces button.urgent {
      background-color: ${urgentColor};
      color: ${colors.bg_primary};
      opacity: 1.0;
    }

    /* === RIGHT MODULES (powerline going left ←) === */

    /* Tray - transparent */
    #tray {
      background-color: transparent;
      color: ${colors.fg_primary};
      padding: 0 10px;
    }

    /* Bluetooth - accent_secondary */
    #bluetooth {
      padding-left: 12px;
      background-color: ${colors.accent_secondary};
      color: ${colors.bg_secondary};
    }

    #bluetooth.connected {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
    }

    #bluetooth.off,
    #bluetooth.disabled {
      background-color: ${colors.bg_tertiary};
      color: ${colors.fg_dim};
    }

    /* Pulseaudio - accent_primary */
    #pulseaudio {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
    }

    /* Weather - accent_tertiary */
    #custom-weather {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    /* Date - accent_secondary */
    #custom-date {
      background-color: ${colors.accent_secondary};
      color: ${colors.bg_secondary};
    }

    /* Battery - accent_primary */
    #battery {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
    }

    #battery.charging {
      background-color: ${colors.accent_secondary};
      color: ${colors.bg_secondary};
    }

    #battery.warning {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    #battery.critical {
      background-color: ${urgentColor};
      color: ${colors.bg_primary};
    }

    /* Clock - accent_primary (last) */
    #clock {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
      padding-right: 12px;
    }
  '';

in {
  imports = [ ./powerline.nix ];

  programs.waybar.style = if pl.enable then powerlineStyle else baseStyle;
}
