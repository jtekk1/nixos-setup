{ pkgs, ... }:

let
  # Sway config for greetd - disable HDMI-A-2
  swayGreetdConfig = pkgs.writeText "greetd-sway-config" ''
    output HDMI-A-2 disable
    exec "${pkgs.greetd.regreet}/bin/regreet; swaymsg exit"
  '';
in
{
  # Enable greetd display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayGreetdConfig}";
        user = "greeter";
      };
    };
  };

  # Ensure sway is available for the greeter
  environment.systemPackages = [ pkgs.sway ];
}
