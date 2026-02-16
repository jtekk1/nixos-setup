{ pkgs, ... }:

{
  # Enable greetd display manager with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet -tr --remember-session --cmd mango --asterisks -g '!!! Welcoem To NixOS !!!'";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = [ pkgs.tuigreet ];
}
