{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.webapps;

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

    # Default webapp configurations
    programs.webapps = {
      enable = mkDefault true;
      browser = mkDefault "chromium";
      createDesktopFiles = mkDefault true;

      apps = {
        audible = mkDefault {
          name = "audible";
          displayName = "Audible";
          url = "https://www.audible.com";
          icon = "audiobook";  # Uses Papirus "audiobook" icon
          categories = [ "AudioVideo" "Audio" "Network" ];
          description = "Audible audiobook service";
          keybinding = "SUPER+SHIFT+A";
        };

        gemini = mkDefault {
          name = "gemini";
          displayName = "Gemini AI";
          url = "https://gemini.google.com/gem/a2e9c5b0e7e1";
          icon = "gemini";
          categories = [ "Network" "X-AI" ];
          description = "Google Gemini AI assistant";
          keybinding = "SUPER+SHIFT+G";
        };

        claude = mkDefault {
          name = "claude";
          displayName = "Claude AI";
          url = "https://claude.ai";
          icon = "claude";
          categories = [ "Network" "X-AI" ];
          description = "Anthropic Claude AI assistant";
          keybinding = "SUPER+SHIFT+C";
        };

        chatgpt = mkDefault {
          name = "chatgpt";
          displayName = "ChatGPT";
          url = "https://chatgpt.com";
          icon = "chatgpt";
          categories = [ "Network" "X-AI" ];
          description = "OpenAI ChatGPT";
          keybinding = "SUPER+SHIFT+O";
        };

        hbomax = mkDefault {
          name = "hbomax";
          displayName = "HBO Max";
          url = "https://www.hbomax.com";
          icon = "hbomax";
          categories = [ "AudioVideo" "Video" ];
          description = "HBO Max streaming service";
          keybinding = "SUPER+SHIFT+H";
        };

        instagram = mkDefault {
          name = "instagram";
          displayName = "Instagram";
          url = "https://www.instagram.com";
          icon = "instagram";
          categories = [ "Network" "X-Social" ];
          description = "Instagram social media";
          keybinding = "SUPER+SHIFT+I";
        };

        zohomail = mkDefault {
          name = "zohomail";
          displayName = "Zoho Mail";
          url = "https://mail.zoho.com";
          icon = "zohomail";
          categories = [ "Network" "Email" "Office" ];
          description = "Zoho Mail client";
          keybinding = "SUPER+SHIFT+M";
        };

        netflix = mkDefault {
          name = "netflix";
          displayName = "Netflix";
          url = "https://netflix.com";
          icon = "netflix";
          categories = [ "AudioVideo" "Video" ];
          description = "Netflix streaming service";
          keybinding = "SUPER+SHIFT+N";
        };

        teams = mkDefault {
          name = "teams";
          displayName = "Microsoft Teams";
          url = "https://teams.microsoft.com";
          icon = "teams";
          categories = [ "Network" "X-Communication" ];
          description = "Microsoft Teams collaboration";
          keybinding = "SUPER+SHIFT+T";
        };

        upwork = mkDefault {
          name = "upwork";
          displayName = "Upwork";
          url = "https://upwork.com";
          icon = "upwork";
          categories = [ "Network" "Office" ];
          description = "Upwork freelancing platform";
          keybinding = "SUPER+SHIFT+U";
        };

        youtube = mkDefault {
          name = "youtube";
          displayName = "YouTube";
          url = "https://youtube.com";
          icon = "youtube";
          categories = [ "AudioVideo" "Video" "Network" ];
          description = "YouTube video platform";
          keybinding = "SUPER+SHIFT+Y";
        };

        nerdfonts-cheatsheet = mkDefault {
          name = "nerdfonts-cheatsheet";
          displayName = "Nerd Fonts Cheat Sheet";
          url = "https://www.nerdfonts.com/cheat-sheet";
          icon = "nerdfonts-cheatsheet";
          categories = [ "Utility" "X-Development" ];
          description = "Nerd Fonts icon reference";
          keybinding = "CTRL+SHIFT+SPACE (Hyprland only)";
        };
      };
    };
  };
}
