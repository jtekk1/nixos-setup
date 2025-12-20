{ config, ... }:

let
  nixSetupsPath = "${config.home.homeDirectory}/NixSetups";
  colors = config.theme.colors;
in {
  # Symlink wlogout icons from NixSetups assets
  home.file.".config/mango/wlogout/icons".source =
    config.lib.file.mkOutOfStoreSymlink
    "${nixSetupsPath}/home/assets/wlogout/mango";

  # Wlogout layout configuration
  home.file.".config/mango/wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "swaylock",
        "text" : "  Lock   ",
        "keybind" : "l"
    }

    {
        "label" : "logout",
        "action" : "loginctl terminate-user $USER",
        "text" : " Logout  ",
        "keybind" : "m"
    }

    {
        "label" : "shutdown",
        "action" : "shutdown -h now",
        "text" : "Shutdown ",
        "keybind" : "d"
    }

    {
        "label" : "reboot",
        "action" : "reboot",
        "text" : " Reboot  ",
        "keybind" : "r"
    }

    {
        "label" : "suspend",
        "action" : "systemctl suspend",
        "text" : " Suspend ",
        "keybind" : "s"
    }

    {
        "label" : "hibernate",
        "action" : "systemctl hibernate",
        "text" : "Hibernate",
        "keybind" : "h"
    }
  '';

  # Wlogout style with neurodivergent color scheme
  home.file.".config/mango/wlogout/style.css".text = ''
    window {
        font-family: HYLeMiaoTiJ,CaskaydiaCove Nerd Font, monospace;
        font-size: 12pt;
        font-weight: bold;
        color: ${colors.accent_secondary};
        background-color: ${colors.rgba.bg_primary 1.0};
    }

    button {
        background-repeat: no-repeat;
        background-position: center;
        font-size: 40px;
        background-size: 60%;
        color: ${colors.fg_primary};
        text-shadow: 0 0 8px ${colors.rgba.accent_secondary 0.6};
    }

    button:hover {
        background-size: 80%;
        color: ${colors.fg_primary};
        text-shadow: 0 0 12px ${colors.rgba.accent_primary 0.8};
        box-shadow: 0 0 25px ${colors.rgba.accent_primary 0.5};
        transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
    }

    #lock {
        background-image: image(url("${nixSetupsPath}/home/assets/wlogout/mango/lock.png"));
    }

    #logout {
        background-image: image(url("${nixSetupsPath}/home/assets/wlogout/mango/logout.png"));
    }

    #logout:hover {
        background-image: image(url("${nixSetupsPath}/home/assets/wlogout/mango/logout.png"));
    }

    #suspend {
        background-image: image(url("${nixSetupsPath}/home/assets/wlogout/mango/sleep.png"));
    }

    #shutdown {
        background-image: image(url("${nixSetupsPath}/home/assets/wlogout/mango/power.png"));
    }

    #reboot {
        background-image: image(url("${nixSetupsPath}/home/assets/wlogout/mango/restart.png"));
    }

    #hibernate {
        background-image: image(url("${nixSetupsPath}/home/assets/wlogout/mango/hibernate.png"));
    }
  '';
}
