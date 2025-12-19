{ pkgs, lib, config, osConfig ? null, ... }:

let
  # Only enable for mango-hypr desktop environment
  isMangoHypr = osConfig != null && osConfig.jtekk.desktop-env == "mango-hypr";

  hyprlock = "hyprlock-safe";  # Uses wrapper with --immediate-render
  loginctl = "${pkgs.systemd}/bin/loginctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

  # Use the dpms-on/dpms-off scripts from dpms-control.nix (runtime compositor detection)
  dpmsOn = "dpms-on";
  dpmsOff = "dpms-off";

  # Lock screen and Bitwarden together
  lockScreen = pkgs.writeShellScript "lock-screen" ''
    #!${pkgs.runtimeShell}
    # Lock Bitwarden if it's running
    ${pkgs.bitwarden-desktop}/bin/bitwarden --lock 2>/dev/null || true

    # Lock the screen
    ${hyprlock}
  '';

in {
  config = lib.mkIf isMangoHypr {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock}";  # Only start hyprlock if not already running
          before_sleep_cmd = "${loginctl} lock-session";
          after_sleep_cmd = "${dpmsOn}; ${loginctl} lock-session";  # Turn on display and ensure lock screen is shown
          inhibit_sleep = 3;  # Wait until screen is locked before allowing sleep
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
        };

        listener = [
          # Lock screen and Bitwarden first
          {
            timeout = 300;  # 5 minutes - lock first
            on-timeout = "${loginctl} lock-session";  # This will trigger lock_cmd
          }

          # Turn off display AFTER lock is established (30 seconds after lock)
          {
            timeout = 330;  # 5.5 minutes - turn off display after lock
            on-timeout = dpmsOff;
            on-resume = "${dpmsOn} && ${brightnessctl} -r && ${loginctl} lock-session";
          }
        ];
      };
    };

    # Make sure wlopm is available for non-Hyprland compositors
    home.packages = [ pkgs.wlopm ];

    # Import HYPRLAND_INSTANCE_SIGNATURE so hyprctl commands work (for Hyprland)
    systemd.user.services.hypridle = {
      Unit.After = lib.mkForce "graphical-session.target";
      Service.Environment = "PATH=/run/current-system/sw/bin";
      Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
    };

    # Make sure Hyprland exports HYPRLAND_INSTANCE_SIGNATURE to systemd (only if using Hyprland)
    wayland.windowManager.hyprland.systemd.variables = lib.mkIf (config.wayland.windowManager.hyprland.enable or false) [ "HYPRLAND_INSTANCE_SIGNATURE" ];
  };
}
