{
  hosts = {
    mini-me = {
      ip = "192.168.0.250";
      interface = "enp1s0";
      hostId = "dac0545b"; # Generated for ZFS migration (Phase 5.0)
    };
    beelink = {
      ip = "192.168.0.251";
      interface = "enp2s0";
      hostId = "5f147d66"; # Generated for ZFS migration (Phase 5.0)
    };
    tank = {
      ip = "192.168.0.252";
      interface = "eno1";
      hostId = "0fe983bc"; # Generated for ZFS migration (Phase 5.0)
    };
    deli = {
      ip = "192.168.0.253";
      interface = "enp0s31f6";
      hostId = "987bb700"; # Generated for ZFS migration (Phase 5.0)
    };
    deepspace = {
      ip = "192.168.0.254";
      interface = "enp10s0";
      hostId = null; # Workstation, not a server
    };
  };

  # Network settings
  gateway = "192.168.0.1";
  nameservers = [
    "192.168.0.250"
    "192.168.0.251"
    "1.1.1.1"
    "8.8.8.8"
  ]; # Blocky (primary, secondary) + Cloudflare fallback
  prefixLength = 24;
  lan = "192.168.0.0/24";
}
