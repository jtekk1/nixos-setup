{ pkgs, lib, osConfig ? null, ... }:

let
  # Only enable for non-mango-hypr desktop environments (e.g., Qtile)
  isNotMangoHypr = osConfig == null || osConfig.jtekk.desktop-env != "mango-hypr";

  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

  # Use wlopm for DPMS control (wlroots-compatible)
  dpmsOff = "${pkgs.wlopm}/bin/wlopm --off '*'";
  dpmsOn = "${pkgs.wlopm}/bin/wlopm --on '*'";

in {
  config = lib.mkIf isNotMangoHypr {
    services.swayidle = {
      enable = true;

      events = [
        { event = "before-sleep"; command = "${loginctl} lock-session"; }
        { event = "after-resume"; command = "${dpmsOn}"; }
        { event = "lock"; command = "${swaylock} -f"; }
      ];

      timeouts = [
        # Lock screen after 5 minutes
        {
          timeout = 300;
          command = "${loginctl} lock-session";
        }

        # Turn off display 30 seconds after lock
        {
          timeout = 330;
          command = dpmsOff;
          resumeCommand = "${dpmsOn} && ${brightnessctl} -r";
        }
      ];
    };

    # Make sure wlopm is available
    home.packages = [ pkgs.wlopm ];
  };
}
