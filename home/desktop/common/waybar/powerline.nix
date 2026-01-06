{ lib, ... }:

# Powerline configuration for waybar
# Configurable separators, tails, and styling options

let
  # Available separator/tail characters
  separatorChars = {
    half-circle = { right = ""; left = ""; };
    triangle = { right = ""; left = ""; };
    inverted-triangle = { right = ""; left = ""; };
    bot-triangle = { right = ""; left = ""; };
    top-triangle = { right = ""; left = ""; };
  };

in {
  # Powerline configuration options
  options.programs.waybar.powerline = {
    enable = lib.mkEnableOption "powerline styling for waybar";

    separators = {
      style = lib.mkOption {
        type = lib.types.enum [ "half-circle" "triangle" "inverted-triangle" "bot-triangle" "top-triangle" ];
        default = "triangle";
        description = "Separator style between modules";
      };
      inverted = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Invert separator direction";
      };
    };

    tails = {
      style = lib.mkOption {
        type = lib.types.enum [ "half-circle" "triangle" "inverted-triangle" "bot-triangle" "top-triangle" ];
        default = "inverted-triangle";
        description = "Tail cap style at end of module groups";
      };
      inverted = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Invert tail direction";
      };
    };

    segment = {
      padding = lib.mkOption {
        type = lib.types.str;
        default = "4px 10px";
        description = "Padding inside segments";
      };
      margin = lib.mkOption {
        type = lib.types.str;
        default = "2px 0";
        description = "Margin around segments";
      };
      fontWeight = lib.mkOption {
        type = lib.types.int;
        default = 600;
        description = "Font weight for segment text";
      };
    };

    separator = {
      size = lib.mkOption {
        type = lib.types.int;
        default = 22;
        description = "Font size for separator characters";
      };
    };

    transitions = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable CSS transitions";
      };
      duration = lib.mkOption {
        type = lib.types.str;
        default = "800ms";
        description = "Transition duration";
      };
      timing = lib.mkOption {
        type = lib.types.str;
        default = "ease-in-out";
        description = "Transition timing function";
      };
    };
  };

  # Export separator characters for use in style.nix
  config._module.args.powerlineChars = separatorChars;
}
