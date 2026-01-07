{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.webapps;

  # Read webapps from shared JSON file (single source of truth)
  webappsJson = builtins.fromJSON (builtins.readFile ../../data/webapps.json);

  # Convert JSON app to Nix app format
  jsonToApp = name: app: {
    inherit (app) name displayName url icon description;
    categories = app.categories or [ "Network" ];
    keybinding = app.keybinding or null;
    useDesktopFile = app.useDesktopFile or false;
  };

  mkWebappDesktop = app: pkgs.makeDesktopItem {
    name = app.name;
    desktopName = app.displayName or app.name;
    comment = app.description or "";
    icon = app.icon or "web-browser";
    exec = ''${pkgs.chromium}/bin/chromium --app="${app.url}" --class="${app.name}"'';
    categories = app.categories or [ "Network" ];
    startupWMClass = app.name;
  };

  # Generate launch command for use in keybindings
  mkWebappCommand = app:
    if app.useDesktopFile or false then
      "${app.name}"
    else
      ''chromium --app="${app.url}"'';
in
{
  options.programs.webapps = {
    enable = mkEnableOption "webapp launcher management";

    browser = mkOption {
      type = types.enum [ "chromium" "firefox" "brave" ];
      default = "chromium";
      description = "Default browser for webapps";
    };

    createDesktopFiles = mkOption {
      type = types.bool;
      default = true;
      description = "Create .desktop files for webapps (shows in app launchers)";
    };

    apps = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Internal name (used for desktop file and WM class)";
          };
          displayName = mkOption {
            type = types.str;
            description = "Display name in app launchers";
          };
          url = mkOption {
            type = types.str;
            description = "URL to open";
          };
          icon = mkOption {
            type = types.str;
            default = "web-browser";
            description = "Icon name";
          };
          categories = mkOption {
            type = types.listOf types.str;
            default = [ "Network" ];
            description = "Desktop categories";
          };
          description = mkOption {
            type = types.str;
            default = "";
            description = "App description";
          };
          useDesktopFile = mkOption {
            type = types.bool;
            default = false;
            description = "Launch via desktop file instead of direct command";
          };
          keybinding = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Suggested keybinding (for documentation)";
          };
        };
      });
      default = {};
      description = "Attribute set of webapps to create";
    };
  };

  config = {
    # Install desktop files if enabled
    home.packages = mkIf cfg.enable (mkIf cfg.createDesktopFiles (
      mapAttrsToList (name: app: mkWebappDesktop app) cfg.apps
    ));

    # Load webapp configurations from JSON
    programs.webapps = {
      enable = mkDefault true;
      browser = mkDefault "chromium";
      createDesktopFiles = mkDefault true;

      apps = mapAttrs jsonToApp webappsJson;
    };
  };
}
