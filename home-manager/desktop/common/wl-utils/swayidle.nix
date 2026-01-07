{ pkgs, lib, osConfig ? null, ... }:

let
  # Enable for desktop environments
  isDesktop = osConfig == null || osConfig.jtekk.desktop-env != "server";

  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

  # Use wlopm for DPMS control (wlroots-compatible)
  dpmsOff = "${pkgs.wlopm}/bin/wlopm --off '*'";
  dpmsOn = "${pkgs.wlopm}/bin/wlopm --on '*'";

in {
  config = lib.mkIf isDesktop {
    services.swayidle = {
      enable = true;

      events = [
        { event = "before-sleep"; command = "${loginctl} lock-session"; }
        { event = "after-resume"; command = "${dpmsOn} && ${brightnessctl} -r"; }
        { event = "lock"; command = "${swaylock} -f"; }
      ];

      timeouts = [
        # Lock screen after 5 minutes
        {
          timeout = 300;
          command = "${loginctl} lock-session";
        }

        # Turn off display after 10 minutes
        {
          timeout = 600;
          command = dpmsOff;
          resumeCommand = "${dpmsOn} && ${brightnessctl} -r";
        }

        # Suspend after 2 hours
        {
          timeout = 7200;
          command = "${loginctl} suspend";
        }
      ];
    };

    # Make sure wlopm is available
    home.packages = [ pkgs.wlopm ];
  };
}
