{ config, pkgs, ... }:

{
  wayland.windowManager.mango = {
    enable = true;
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
    # Run autostart script (no longer called automatically in latest mango)
    settings = ''
      exec-once=~/.config/mango/autostart.sh
    '';
  };

  programs.wlogout.enable = true;

  home.packages = with pkgs; [
    libsForQt5.qt5ct

    gnome-backgrounds
    jq
    socat
    ripgrep
    fd
  ];
}
