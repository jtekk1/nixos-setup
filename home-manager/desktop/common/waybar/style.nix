{ pkgs, lib, config, osConfig ? null, ... }:

let
  colors = config.theme.colors;
  pl = config.programs.waybar.powerline;

  # Host detection for conditional styling
  hostname = if osConfig != null then
    osConfig.networking.hostName
  else
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile /etc/hostname);
  isDeepspace = hostname == "deepspace";
  isThinkpad = hostname == "thinkpad";

  # Cap colors - left cap matches first module (power), right cap matches last module (clock)
  leftCapColor = colors.accent_primary;
  rightCapColor = colors.accent_primary;

  # Theme colors with fallbacks
  primaryColor =
    if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null then
      colors.mangoOverrides.focuscolor
    else
      colors.accent_primary;
  urgentColor =
    if config.theme.name == "neuro-fusion" && colors.mangoOverrides != null then
      colors.mangoOverrides.urgentcolor
    else
      colors.accent_secondary;

  # Separator characters
  separatorChars = {
    half-circle = {
      right = "";
      left = "";
    };
    triangle = {
      right = "";
      left = "";
    };
    inverted-triangle = {
      right = "";
      left = "";
    };
    bot-triangle = {
      right = "";
      left = "";
    };
    top-triangle = {
      right = "";
      left = "";
    };
  };

  # Get separator characters based on config
  sepStyle = separatorChars.${pl.separators.style};
  capStyle = separatorChars.${pl.caps.style};

  # Handle inversion
  sepRight = if pl.separators.inverted then sepStyle.left else sepStyle.right;
  sepLeft = if pl.separators.inverted then sepStyle.right else sepStyle.left;
  capRight = if pl.caps.inverted then capStyle.left else capStyle.right;
  capLeft = if pl.caps.inverted then capStyle.right else capStyle.left;

  # Color cycling for modules (primary -> secondary -> tertiary)
  accentColors =
    [ colors.accent_primary colors.accent_secondary colors.accent_tertiary ];

  # Base style (non-powerline)
  baseStyle = ''
    * {
      font-family: CaskaydiaCove Nerd Font Propo, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
      font-size: 12px;
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
      background-color: ${colors.rgba.bg_primary 0.65};
      border: none;
    }

    /* Segment base styling */
    .modules-left > widget > *,
    .modules-right > widget > * {
      padding: ${pl.segment.padding};
      margin: ${pl.segment.margin};
      font-weight: ${toString pl.segment.fontWeight};
      ${
        if pl.transitions.enable then ''
          transition: all ${pl.transitions.duration} ${pl.transitions.timing};
        '' else
          ""
      }
    }

    /* === LEFT MODULES (powerline going right →) === */

    /* Power - accent_primary */
    #custom-power {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
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
    }

    /* Left cap - start of left modules */
    #custom-left-cap {
      background-color: transparent;
      color: ${leftCapColor};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    /* Left end separators - to transparent (pointing right →) */
    #custom-sep-1T {
      background-color: transparent;
      color: ${colors.accent_primary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-2T {
      background-color: transparent;
      color: ${colors.accent_secondary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    /* Separators - transition between color themes */
    #custom-sep-12 {
      background-color: ${colors.accent_secondary};
      color: ${colors.accent_primary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-23 {
      background-color: ${colors.accent_tertiary};
      color: ${colors.accent_secondary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-31 {
      background-color: ${colors.accent_primary};
      color: ${colors.accent_tertiary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    /* Left-side separators second cycle (l2) */
    #custom-sep-12-l2 {
      background-color: ${colors.accent_secondary};
      color: ${colors.accent_primary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-23-l2 {
      background-color: ${colors.accent_tertiary};
      color: ${colors.accent_secondary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-31-l2 {
      background-color: ${colors.accent_primary};
      color: ${colors.accent_tertiary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    /* Right-side separators - sep-XY: bg=X, fg=Y */
    #custom-sep-13 {
      background-color: ${colors.accent_primary};
      color: ${colors.accent_tertiary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-21 {
      background-color: ${colors.accent_secondary};
      color: ${colors.accent_primary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-32 {
      background-color: ${colors.accent_tertiary};
      color: ${colors.accent_secondary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    /* === CENTER MODULES === */

    /* Center separators - sep-T2-l (←) on left, sep-T2-r (→) on right */
    #custom-sep-T2-l,
    #custom-sep-T2-r {
      background-color: transparent;
      color: ${colors.accent_secondary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #workspaces {
      background-color: ${colors.accent_secondary};
      margin: 2px 0;
    }

    #workspaces button {
      background-color: transparent;
      color: ${colors.bg_secondary};
      opacity: 0.9;
      padding: 0 8px;
      margin: 0 2px;
      border-radius: 0;
      box-shadow: none;
      transition: all ${pl.transitions.duration} ${pl.transitions.timing};
    }

    #workspaces button:hover {
      background-color: ${colors.bg_secondary};
      color: ${colors.accent_secondary};
      opacity: 1.0;
    }

    #workspaces button.active {
      background-color: transparent;
      opacity: 1.0;
      color: ${colors.bg_primary};
      box-shadow: none;
    }

    #workspaces button.hidden {
      background-color: transparent;
      opacity: 0.35;
      color: ${colors.bg_tertiary};
    }

    #workspaces button.urgent {
      background-color: transparent;
      color: ${colors.color5};
      opacity: 1.0;
    }

    /* === RIGHT MODULES === */
    /* Deepspace: sepT1 -> volume(1) -> sep-13 -> weather(3) -> sep-32 -> date(2) -> sep-21 -> clock(1) */
    /* Thinkpad: sepT2 -> volume(2) -> sep-21 -> weather(1) -> sep-13 -> battery(3) -> sep-32 -> date(2) -> sep-21 -> clock(1) */

    /* Tray - transparent */
    #tray {
      background-color: transparent;
      color: ${colors.fg_primary};
      padding: 0 10px;
    }

    /* Bluetooth - color 3 (thinkpad powerline) */
    #bluetooth {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    #bluetooth.connected {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    #bluetooth.off,
    #bluetooth.disabled {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
      opacity: 0.6;
    }

    /* Transparent to color separators - bg=T, fg=color */
    #custom-sep-T1 {
      background-color: transparent;
      color: ${colors.accent_primary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-T2 {
      background-color: transparent;
      color: ${colors.accent_secondary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-T3 {
      background-color: transparent;
      color: ${colors.accent_tertiary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    /* Pulseaudio - color 1 on deepspace, color 2 on thinkpad */
    #pulseaudio {
      background-color: ${
        if isDeepspace then colors.accent_primary else colors.accent_secondary
      };
      color: ${if isDeepspace then colors.bg_primary else colors.bg_secondary};
    }

    /* Weather - color 3 on deepspace, color 1 on thinkpad */
    #custom-weather {
      background-color: ${
        if isDeepspace then colors.accent_tertiary else colors.accent_primary
      };
      color: ${if isDeepspace then colors.bg_tertiary else colors.bg_primary};
    }

    /* Battery - color 3 (thinkpad only) */
    #battery {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    #battery.charging,
    #battery.warning {
      background-color: ${colors.accent_tertiary};
      color: ${colors.bg_tertiary};
    }

    #battery.critical {
      background-color: ${urgentColor};
      color: ${colors.bg_primary};
    }

    /* Date - color 2 */
    #custom-date {
      background-color: ${colors.accent_secondary};
      color: ${colors.bg_secondary};
    }

    /* Clock - color 1 */
    #clock {
      background-color: ${colors.accent_primary};
      color: ${colors.bg_primary};
    }

    /* Right-side separators - sep-XY: bg=X, fg=Y */
    #custom-sep-13-r {
      background-color: ${colors.accent_primary};
      color: ${colors.accent_tertiary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-21-r,
    #custom-sep-21-r2 {
      background-color: ${colors.accent_secondary};
      color: ${colors.accent_primary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-31-r {
      background-color: ${colors.accent_tertiary};
      color: ${colors.accent_primary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    #custom-sep-32-r {
      background-color: ${colors.accent_tertiary};
      color: ${colors.accent_secondary};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }

    /* Right cap - end of right modules */
    #custom-right-cap {
      background-color: transparent;
      color: ${rightCapColor};
      font-size: ${toString pl.separator.size}px;
      padding: 0;
      margin: ${pl.segment.margin};
    }
  '';

in {
  imports = [ ./powerline.nix ];

  programs.waybar.style = if pl.enable then powerlineStyle else baseStyle;
}
