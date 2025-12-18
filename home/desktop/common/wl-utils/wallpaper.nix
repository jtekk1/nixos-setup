{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.wallpaper;

  # Define unified-wallpaper script here so we can reference it in systemd services
  unified-wallpaper = pkgs.writeShellScriptBin "unified-wallpaper" ''
    #!/usr/bin/env bash

    # Ensure PATH includes coreutils and other required tools
    export PATH="${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.procps}/bin:$PATH"

    # Unified wallpaper changer for hyprland, mango, and cosmic
    # Supports multiple modes: next/previous, random, time-based, specific

    # Configuration
    CONFIG_DIR="$HOME/.config/wallpaper"
    STATE_FILE="$CONFIG_DIR/current"
    HISTORY_FILE="$CONFIG_DIR/history"
    INDEX_FILE="$CONFIG_DIR/index"

    # Default wallpaper directories (in priority order)
    WALLPAPER_DIRS=(
      "$HOME/Pictures/nix"
    )

    # Transition settings for swww
    TRANSITION_TYPE="fade"
    TRANSITION_DURATION="3"
    TRANSITION_FPS="60"

    # Create config directory if it doesn't exist
    mkdir -p "$CONFIG_DIR"

    # Function to print usage
    usage() {
      echo "Usage: $(basename $0) [OPTIONS]"
      echo "Options:"
      echo "  (no args)     Cycle to next wallpaper"
      echo "  -n, --next    Cycle to next wallpaper (same as no args)"
      echo "  -p, --prev    Cycle to previous wallpaper"
      echo "  -r, --random  Select a random wallpaper"
      echo "  -t, --time    Select wallpaper based on time of day"
      echo "  -s, --set PATH  Set specific wallpaper"
      echo "  -l, --list    List all available wallpapers"
      echo "  -c, --current Show current wallpaper"
      echo "  -h, --help    Show this help message"
      exit 0
    }

    # Function to detect running compositor
    detect_compositor() {
      if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "hyprland"
      elif pgrep -x mango > /dev/null; then
        echo "mango"
      else
        echo "unknown"
      fi
    }

    # Function to ensure swww daemon is running
    ensure_swww_daemon() {
      # Check if swww can query (daemon is running and responsive)
      if ! ${pkgs.swww}/bin/swww query &>/dev/null; then
        ${pkgs.swww}/bin/swww-daemon &
        sleep 0.5
      fi
    }

    # Function to get all wallpapers
    get_all_wallpapers() {
      local wallpapers=()

      for dir in "''${WALLPAPER_DIRS[@]}"; do
        if [ -d "$dir" ]; then
          while IFS= read -r -d $'\0' file; do
            wallpapers+=("$file")
          done < <(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.webp" \) -print0 2>/dev/null)
        fi
      done

      # Sort for consistent ordering
      printf '%s\n' "''${wallpapers[@]}" | sort -u
    }

    # Function to get current wallpaper index
    get_current_index() {
      if [ -f "$INDEX_FILE" ]; then
        cat "$INDEX_FILE"
      else
        echo "0"
      fi
    }

    # Function to save current wallpaper and index
    save_state() {
      local wallpaper="$1"
      local index="$2"

      echo "$wallpaper" > "$STATE_FILE"
      echo "$index" > "$INDEX_FILE"

      # Create/update symlink for hyprlock
      mkdir -p "$HOME/.config/hyprlock"
      ln -sf "$wallpaper" "$HOME/.config/hyprlock/current-wallpaper"

      # Add to history (keep last 100 entries)
      echo "$wallpaper" >> "$HISTORY_FILE"
      tail -n 100 "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    }

    # Function to set wallpaper
    set_wallpaper() {
      local wallpaper="$1"

      if [ ! -f "$wallpaper" ]; then
        echo "Error: Wallpaper file not found: $wallpaper"
        exit 1
      fi

      ensure_swww_daemon

      # Get current wallpaper before change
      local before=$(${pkgs.swww}/bin/swww query 2>/dev/null | grep -o 'image: .*' | cut -d' ' -f2)

      # Set wallpaper with swww
      ${pkgs.swww}/bin/swww img "$wallpaper" \
        --transition-type "$TRANSITION_TYPE" \
        --transition-duration "$TRANSITION_DURATION" \
        --transition-fps "$TRANSITION_FPS"

      # Verify the change happened, restart daemon if stuck
      sleep 0.5
      local after=$(${pkgs.swww}/bin/swww query 2>/dev/null | grep -o 'image: .*' | cut -d' ' -f2)
      if [ "$before" = "$after" ] && [ "$wallpaper" != "$after" ]; then
        echo "Daemon stuck, restarting..."
        pkill swww-daemon 2>/dev/null
        sleep 0.5
        ${pkgs.swww}/bin/swww-daemon &
        sleep 0.5
        ${pkgs.swww}/bin/swww img "$wallpaper" \
          --transition-type "$TRANSITION_TYPE" \
          --transition-duration "$TRANSITION_DURATION" \
          --transition-fps "$TRANSITION_FPS"
      fi

      echo "Wallpaper changed to: $(basename "$wallpaper")"
    }

    # Function to cycle to next wallpaper
    next_wallpaper() {
      local wallpapers=()
      readarray -t wallpapers < <(get_all_wallpapers)

      if [ ''${#wallpapers[@]} -eq 0 ]; then
        echo "Error: No wallpapers found"
        exit 1
      fi

      local current_index=$(get_current_index)
      local next_index=$(( (current_index + 1) % ''${#wallpapers[@]} ))

      set_wallpaper "''${wallpapers[$next_index]}"
      save_state "''${wallpapers[$next_index]}" "$next_index"
    }

    # Function to cycle to previous wallpaper
    prev_wallpaper() {
      local wallpapers=()
      readarray -t wallpapers < <(get_all_wallpapers)

      if [ ''${#wallpapers[@]} -eq 0 ]; then
        echo "Error: No wallpapers found"
        exit 1
      fi

      local current_index=$(get_current_index)
      local prev_index=$(( (current_index - 1 + ''${#wallpapers[@]}) % ''${#wallpapers[@]} ))

      set_wallpaper "''${wallpapers[$prev_index]}"
      save_state "''${wallpapers[$prev_index]}" "$prev_index"
    }

    # Function to select random wallpaper
    random_wallpaper() {
      local wallpapers=()
      readarray -t wallpapers < <(get_all_wallpapers)

      if [ ''${#wallpapers[@]} -eq 0 ]; then
        echo "Error: No wallpapers found"
        exit 1
      fi

      local random_index=$((RANDOM % ''${#wallpapers[@]}))

      set_wallpaper "''${wallpapers[$random_index]}"
      save_state "''${wallpapers[$random_index]}" "$random_index"
    }

    # Function to select time-based wallpaper
    time_based_wallpaper() {
      local hour=$(date +%H)
      local pattern=""

      # Determine day or night
      if [ $hour -ge 6 ] && [ $hour -lt 18 ]; then
        # Daytime (6am-6pm)
        pattern="day"
      else
        # Nighttime
        pattern="night"
      fi

      # First, try to find wallpapers with day/night in name
      local themed_wallpapers=()
      for dir in "''${WALLPAPER_DIRS[@]}"; do
        if [ -d "$dir" ]; then
          while IFS= read -r -d $'\0' file; do
            if [[ "$(basename "$file")" == *"$pattern"* ]]; then
              themed_wallpapers+=("$file")
            fi
          done < <(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 2>/dev/null)
        fi
      done

      if [ ''${#themed_wallpapers[@]} -gt 0 ]; then
        # Use a day/night themed wallpaper
        local random_index=$((RANDOM % ''${#themed_wallpapers[@]}))
        set_wallpaper "''${themed_wallpapers[$random_index]}"

        # Find index in main list for consistency
        local all_wallpapers=()
        readarray -t all_wallpapers < <(get_all_wallpapers)
        for i in "''${!all_wallpapers[@]}"; do
          if [[ "''${all_wallpapers[$i]}" == "''${themed_wallpapers[$random_index]}" ]]; then
            save_state "''${themed_wallpapers[$random_index]}" "$i"
            return
          fi
        done
      else
        # Fall back to random if no themed wallpapers found
        echo "No $pattern-themed wallpapers found, selecting random..."
        random_wallpaper
      fi
    }

    # Function to list all wallpapers
    list_wallpapers() {
      echo "Available wallpapers:"
      echo "===================="

      local wallpapers=()
      readarray -t wallpapers < <(get_all_wallpapers)

      if [ ''${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in configured directories"
        return
      fi

      for i in "''${!wallpapers[@]}"; do
        local current_marker=""
        if [ -f "$STATE_FILE" ] && [ "''${wallpapers[$i]}" = "$(cat "$STATE_FILE")" ]; then
          current_marker=" [CURRENT]"
        fi
        printf "[%3d] %s%s\n" "$i" "$(basename "''${wallpapers[$i]}")" "$current_marker"
      done

      echo ""
      echo "Total: ''${#wallpapers[@]} wallpapers"
    }

    # Function to show current wallpaper
    show_current() {
      if [ -f "$STATE_FILE" ]; then
        local current=$(cat "$STATE_FILE")
        echo "Current wallpaper: $(basename "$current")"
        echo "Full path: $current"
        if [ -f "$INDEX_FILE" ]; then
          echo "Index: $(cat "$INDEX_FILE")"
        fi
      else
        echo "No wallpaper currently set"
      fi
    }

    # Main script logic
    case "''${1:-}" in
      -n|--next|"")
        next_wallpaper
        ;;
      -p|--prev|--previous)
        prev_wallpaper
        ;;
      -r|--random)
        random_wallpaper
        ;;
      -t|--time)
        time_based_wallpaper
        ;;
      -s|--set)
        if [ -z "''${2:-}" ]; then
          echo "Error: Please provide a wallpaper path"
          exit 1
        fi
        set_wallpaper "$2"
        # Try to find index for consistency
        readarray -t all_wallpapers < <(get_all_wallpapers)
        for i in "''${!all_wallpapers[@]}"; do
          if [[ "''${all_wallpapers[$i]}" == "$2" ]]; then
            save_state "$2" "$i"
            exit 0
          fi
        done
        # If not in list, just save with index 0
        save_state "$2" "0"
        ;;
      -l|--list)
        list_wallpapers
        ;;
      -c|--current)
        show_current
        ;;
      -h|--help)
        usage
        ;;
      *)
        echo "Error: Unknown option: $1"
        usage
        ;;
    esac
  '';
in
{
  options.programs.wallpaper = {
    enable = mkEnableOption "wallpaper management with swww";

    autoRotate = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable automatic wallpaper rotation";
      };

      interval = mkOption {
        type = types.str;
        default = "15min";
        description = "Systemd timer interval for wallpaper rotation (e.g., 15min, 30min, 1h)";
      };

      mode = mkOption {
        type = types.enum [ "next" "random" "time" ];
        default = "next";
        description = "Mode for automatic wallpaper rotation";
      };
    };

    directories = mkOption {
      type = types.listOf types.str;
      default = [
        "/home/jtekk/NixSetups/home/assets/backgrounds"
        "~/Pictures/bluefin-dinos"
        "~/Pictures/backgrounds"
        "~/Pictures/wallpapers"
      ];
      description = "Directories to search for wallpapers";
    };
  };

  config = mkIf cfg.enable {
    # Install swww package and unified-wallpaper script
    home.packages = [
      pkgs.swww
      unified-wallpaper
    ];

    # Systemd service for swww daemon
    systemd.user.services.swww-daemon = {
      Unit = {
        Description = "Swww wallpaper daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        # Kill any existing swww-daemon and clean stale socket before starting
        ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.procps}/bin/pkill -x swww-daemon 2>/dev/null || true; ${pkgs.coreutils}/bin/sleep 0.3; rm -f \"$XDG_RUNTIME_DIR/swww-\"*.socket 2>/dev/null || true'";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Systemd service to restore wallpaper on startup
    systemd.user.services.wallpaper-restore = {
      Unit = {
        Description = "Restore current wallpaper on startup";
        After = [ "swww-daemon.service" ];
        Requires = [ "swww-daemon.service" ];
      };

      Service = {
        Type = "oneshot";
        # Add delay to ensure swww-daemon is fully ready
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
        ExecStart = "${pkgs.bash}/bin/bash -c 'if [ -f $HOME/.config/wallpaper/current ]; then ${unified-wallpaper}/bin/unified-wallpaper --set \"$(${pkgs.coreutils}/bin/cat $HOME/.config/wallpaper/current)\"; else ${unified-wallpaper}/bin/unified-wallpaper; fi'";
      };

      Install = {
        WantedBy = [ "swww-daemon.service" ];
      };
    };

    # Systemd service for wallpaper rotation
    systemd.user.services.wallpaper-rotate = mkIf cfg.autoRotate.enable {
      Unit = {
        Description = "Rotate wallpaper";
        After = [ "swww-daemon.service" "wallpaper-restore.service" ];
        Requires = [ "swww-daemon.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = let
          modeFlag = {
            "next" = "";
            "random" = "--random";
            "time" = "--time";
          }.${cfg.autoRotate.mode};
        in "${unified-wallpaper}/bin/unified-wallpaper ${modeFlag}";
      };
    };

    # Systemd timer for wallpaper rotation
    systemd.user.timers.wallpaper-rotate = mkIf cfg.autoRotate.enable {
      Unit = {
        Description = "Timer for wallpaper rotation";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Timer = {
        OnBootSec = "1min";
        OnUnitActiveSec = cfg.autoRotate.interval;
        Persistent = true;
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    # Create initial wallpaper config directory
    home.activation.createWallpaperConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.config/wallpaper
    '';
  };
}