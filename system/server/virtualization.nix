{ config, pkgs, ... }:

{
  # Enable Podman for container management
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # Create docker alias for compatibility
    # Enable container auto-update
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # Enable Podman socket for Docker API compatibility
  systemd.user.services.podman-socket = {
    enable = true;
    wantedBy = [ "default.target" ];
  };

  # Additional container tools
  environment.systemPackages = with pkgs; [
    podman-compose  # Docker-compose compatibility
    podman-tui      # Terminal UI for managing containers
    dive            # Analyze container images
    skopeo          # Work with container images

    # Virtual TPM tools (for VM secure boot, etc.)
    swtpm
  ];

  networking.firewall.allowedTCPPorts = [
    3000   # Grafana
    9090   # Prometheus
    3100   # Loki
    80     # HTTP (for reverse proxy)
    443    # HTTPS (for reverse proxy)
    9443   # Portainer HTTPS
    8000   # Portainer agent
  ];

  # Podman network settings
  virtualisation.podman.defaultNetwork.settings = {
    dns_enabled = true;
    metric = {
      enabled = true;
    };
  };

  # Declarative containers
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";
        ports = [ "9443:9443" "8000:8000" ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];
        autoStart = true;
      };
    };
  };
  
  # KVM/QEMU virtual machines
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;  # For virtual TPM
    };
  };

  programs.virt-manager.enable = true;

  # Add user to libvirtd group for VM management
  users.users.jtekk.extraGroups = [ "libvirtd" ];

  # Set DOCKER_HOST environment variable for Podman socket
  environment.sessionVariables = {
    DOCKER_HOST = "unix:///run/user/$UID/podman/podman.sock";
    COMPOSE_PROVIDER = "podman-compose";  # Suppress external provider message
  };
}
