{ pkgs, config, ... }:

{
  # Utility packages
  home.packages = with pkgs; [
    yad
    appimage-run
  ];

  # Hyprland-specific environment variables
  # Note: XDG_CURRENT_DESKTOP is set by the session/greeter at login
  home.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    OZONE_PLATFORM = "wayland";
  };

  wayland.windowManager.hyprland.settings = {
    # Autostart
    exec-once = [
      "hyprctl setcursor Bibata-Modern-Classic 24"
      "uwsm app -- hypridle"
      "uwsm app -- mako"
      "uwsm app -- waybar"
      "uwsm app -- swayosd-server"
      "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
      "wl-clip-persist --clipboard regular --all-mime-type-regex '^(?!x-kde-passwordManagerHint).+'"
      # Wallpaper management handled by systemd services (swww-daemon.service, wallpaper-restore.service)
    ];

    # Environment
    env = [ "GDK_SCALE,1" ];

    xwayland = { force_zero_scaling = true; };

    ecosystem = { no_update_news = false; };

    # Input configuration
    input = {
      kb_layout = "us";
      kb_options = "compose:caps";
      follow_mouse = 1;
      repeat_rate = 40;
      repeat_delay = 600;
      numlock_by_default = true;
      sensitivity = 0.15;

      touchpad = {
        natural_scroll = false;
        scroll_factor = 0.4;
      };
    };

    # Window Decoration - Look and Feel
    general = {
      gaps_in = 10;
      gaps_out = 10;
      border_size = 5;
      "col.active_border" = let
        c1 = config.theme.colors.rgba.border_active_1 1.0;
        c2 = config.theme.colors.rgba.border_active_2 1.0;
      in "${c1} ${c2} ${c1} ${c2} 45deg";
      "col.inactive_border" = let
        # Create gradient with varying opacity for inactive borders
        c1 = config.theme.colors.rgba.border_active_1 0.4;
        c2 = config.theme.colors.rgba.border_active_2 0.47;
        c3 = config.theme.colors.rgba.border_active_1 0.53;
        c4 = config.theme.colors.rgba.border_active_2 0.6;
      in "${c1} ${c2} ${c3} ${c4} 45deg";
      layout = "dwindle";
      resize_on_border = true;
    };

    decoration = {
      rounding = 2;

      blur = {
        enabled = true;
        size = 8;
        passes = 2;
        new_optimizations = true;
        xray = false;
        noise = 2.0e-2;
        contrast = 1.0;
        brightness = 0.9;
      };

      shadow = {
        enabled = true;
        range = 30;
        render_power = 5;
      };

      active_opacity = 1.0;
      inactive_opacity = 0.88;
      fullscreen_opacity = 1.0;
    };

    animations = {
      enabled = true;

      bezier = [ "flash, 1, -0.55, 0.04, 1.1" ];

      animation = [
        "windows, 1, 2.3, flash, slide"
        "windowsIn, 1, 2.3, flash, slide up"
        "windowsOut, 1, 2.3, flash, slide down"
        "windowsMove, 1, 2.3, flash, slide"
        "layers, 1, 2.3, flash, slide"
        "layersIn, 1, 2.3, flash, slide up"
        "layersOut, 1, 2.3, flash, slide down"
        "fade, 1, 2.3, flash"
        "fadeIn, 1, 2.3, flash"
        "fadeOut, 1, 2.3, flash"
        "fadeSwitch, 1, 2.3, flash"
        "fadeShadow, 1, 2.3, flash"
        "fadeDim, 1, 2.3, flash"
        "fadeLayers, 1, 2.3, flash"
        "fadeLayersIn, 1, 2.3, flash"
        "fadeLayersOut, 1, 2.3, flash"
        "border, 1, 1, flash"
        "borderangle, 1, 600, flash, loop"
        "workspaces, 1, 2.3, flash, slidefade"
        "workspacesIn, 1, 2.3, flash, slidefadevert 80%"
        "workspacesOut, 1, 2.3, flash, slidefadevert 80%"
        "specialWorkspace, 1, 2.3, flash, slidefadevert 90%"
        "specialWorkspaceIn, 1, 2.3, flash, slidefadevert 90%"
        "specialWorkspaceOut, 1, 2.3, flash, slidefadevert 90%"
      ];
    };

    # Layout configuration
    dwindle = {
      pseudotile = true;
      preserve_split = true;
      force_split = 2;
    };

    master = { new_status = "master"; };

    misc = {
      disable_hyprland_logo = false;
      disable_splash_rendering = false;
      focus_on_activate = true;
      middle_click_paste = false;
    };

    # Monitor configuration
    monitor = [
      "desc:Dell Inc. DELL U4025QW 9750B34, 5120x2160@120.00, auto, 1.0666667"
      "desc:MS Telematica MStar Demo 0x00000001, disable"
      #"desc:MS Telematica MStar Demo 0x00000001, preferred, auto-right, auto"
      #",preferred,auto,auto"
    ];

    # Window rules (Hyprland 0.52+ syntax)
    windowrule = [
      # Default opacity
      "opacity 0.97 0.9, class:.*"

      # Suppress maximize events
      "suppressevent maximize, class:.*"

      # Fix XWayland dragging issues
      "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pin:0"
    ];
  };
}
