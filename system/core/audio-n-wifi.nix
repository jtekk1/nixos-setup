{ pkgs, config, lib, ... }:

{
  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.wireplumber.enable = true;

  # Enable iwd service for wireless networking (required for impala)
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
      };
    };
  };

  # Restart iwd and dhcpcd after suspend to fix DNS resolution issues
  # iwd must be restarted first, then dhcpcd to properly restore DNS via resolvconf
  # Also need to unblock RF-kill which gets soft-blocked on resume
  systemd.services."network-restart-after-resume" = {
    description = "Restart network services after resuming from suspend";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Unblock RF-kill first, restart iwd, wait for it to be ready, then restart dhcpcd
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.util-linux}/bin/rfkill unblock wifi && sleep 1 && ${pkgs.systemd}/bin/systemctl restart iwd.service && sleep 3 && ${pkgs.systemd}/bin/systemctl restart dhcpcd.service'";
    };
  };

  environment.systemPackages = with pkgs; [
    wiremix
    blueberry
    blanket      # Ambient sound / white noise app
    iwd
    impala
    imv
    mpv
    playerctl
  ];
}

