{ config, ... }:

let nixSetupsPath = "${config.home.homeDirectory}/NixSetups";
in {
  # Symlink wlogout icons from NixSetups assets
  home.file.".config/mango/wlogout/icons".source =
    config.lib.file.mkOutOfStoreSymlink "${nixSetupsPath}/home/assets/wlogout";

  # Wlogout layout configuration
  home.file.".config/mango/wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "hyprlock",
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

  # Wlogout style with neurodivergent Hyprland color scheme
  home.file.".config/mango/wlogout/style.css".text = ''
    window {
        font-family: HYLeMiaoTiJ,CaskaydiaCove Nerd Font, monospace;
        font-size: 12pt;
        font-weight: bold;
        color: #00FFFF;
        background-color: rgba(20, 0, 30, 0.85);
    }

    button {
        background-repeat: no-repeat;
        background-position: center;
        font-size: 40px;
        background-size: 60%;
        border: 3px solid rgba(0, 255, 255, 0.3);
        color: #00FFFF;
        text-shadow: 0 0 8px rgba(0, 255, 255, 0.6);
        border-radius: 20px;
        background-color: rgba(0, 255, 255, 0.05);
        margin-top: 120px;
        margin-bottom: 120px;
        transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
        box-shadow: 0 0 15px rgba(0, 255, 255, 0.2);
    }

    button:hover {
        background-color: rgba(221, 0, 255, 0.35);
        background-size: 80%;
        border: 3px solid rgba(221, 0, 255, 0.8);
        color: #DD00FF;
        text-shadow: 0 0 12px rgba(221, 0, 255, 0.8);
        box-shadow: 0 0 25px rgba(221, 0, 255, 0.5);
        transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
    }

    #lock {
        background-image: image(url("./icons/lock.png"));
    }

    #logout {
        background-image: image(url("./icons/logout.png"));
    }

    #logout:hover {
        background-image: image(url("./icons/logout.png"));
    }

    #suspend {
        background-image: image(url("./icons/sleep.png"));
    }

    #shutdown {
        background-image: image(url("./icons/power.png"));
    }

    #reboot {
        background-image: image(url("./icons/restart.png"));
    }

    #hibernate {
        background-image: image(url("./icons/hibernate.png"));
    }
  '';
}
