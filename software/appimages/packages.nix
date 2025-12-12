# AppImage package definitions and configuration
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.appimages;

  # Import our helper library
  appImageLib = import ./lib.nix { inherit lib pkgs; };

  # Define all available AppImage packages
  # Each package is imported from the packages/ directory
  allPackages = {
    cursor = pkgs.callPackage ./packages/cursor.nix { inherit appImageLib; };
  };

  # Filter packages based on user configuration
  enabledPackages = filterAttrs (name: package:
    cfg.packages.${name}.enable or false
  ) allPackages;

  # Package option type definition
  packageOptionType = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install this AppImage";
      };

      priority = mkOption {
        type = types.int;
        default = 10;
        description = "Priority for this package (lower is higher priority)";
      };

      extraLibraries = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "Additional libraries this specific AppImage needs";
      };

      extraEnv = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Extra environment variables for this AppImage";
        example = literalExpression ''
          {
            QT_QPA_PLATFORM = "wayland";
            GDK_BACKEND = "wayland";
          }
        '';
      };
    };
  };
in
{
  options.programs.appimages = {
    packages = mkOption {
      type = types.attrsOf packageOptionType;
      default = {};
      description = "AppImage packages to install";
      example = literalExpression ''
        {
          cursor = {
            enable = true;
            extraEnv = {
              NIXOS_OZONE_WL = "1";
            };
          };
          obsidian = {
            enable = true;
          };
        }
      '';
    };

    # Quick enable options for common packages
    enableCursor = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Cursor IDE AppImage";
    };

    # Package groups for convenience
    enableDevelopmentApps = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all development-related AppImages (Cursor, etc.)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Apply quick enable options
    {
      programs.appimages.packages = mkMerge [
        (mkIf cfg.enableCursor {
          cursor.enable = true;
        })

        # Package groups
        (mkIf cfg.enableDevelopmentApps {
          cursor.enable = true;
          # Add more dev tools here as we add them
        })
      ];
    }

    # Install enabled packages
    {
      environment.systemPackages = attrValues enabledPackages;
    }

    # Add any package-specific environment variables
    {
      environment.sessionVariables = mkMerge (
        mapAttrsToList (name: pkg:
          if cfg.packages.${name}.enable or false
          then cfg.packages.${name}.extraEnv
          else {}
        ) allPackages
      );
    }

    # Ensure unfree packages are allowed if needed
    {
      nixpkgs.config.allowUnfreePredicate = pkg:
        let
          packageName = getName pkg;
          # List of AppImage packages that are unfree
          unfreeAppImages = [
            "cursor"
            # Add more as needed
          ];
        in
          (elem packageName unfreeAppImages && cfg.packages.${packageName}.enable or false) ||
          config.nixpkgs.config.allowUnfreePredicate pkg;
    }
  ]);
}