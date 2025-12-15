{ config, lib, pkgs, ... }:

{
  # Gitea Actions Runner - CI/CD worker for Gitea
  # Uses Podman for job isolation

  # Configure container registries - default to docker.io and disable interactive prompts
  virtualisation.containers.registries.search = [ "docker.io" "ghcr.io" ];
  virtualisation.containers.containersConf.settings.engine.short_name_mode = "disabled";

  # Enable podman with rootless support for CI builds
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # Provides docker alias
  };

  # Create static gitea-runner user with subuid/subgid for rootless podman
  users.users.gitea-runner = {
    isSystemUser = true;
    group = "gitea-runner";
    home = "/var/lib/gitea-runner";
    createHome = true;
    subUidRanges = [{ startUid = 200000; count = 65536; }];
    subGidRanges = [{ startGid = 200000; count = 65536; }];
  };
  users.groups.gitea-runner = {};

  # Sops secret for runner registration token
  # Mode 0444 allows the gitea-runner dynamic user to read the token
  # The token is only used once for registration, then a different auth is used
  sops.secrets."gitea/runner_token" = {
    sopsFile = ../../secrets/common.yaml;
    key = "gitea/runner_token";
    mode = "0444";
  };

  services.gitea-actions-runner = {
    package = pkgs.gitea-actions-runner;

    instances = {
      "default" = {
        enable = true;
        name = config.networking.hostName;
        url = "https://git.jtekk.dev";
        tokenFile = config.sops.secrets."gitea/runner_token".path;

        labels = [
          "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
          "ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
          "fedora-latest:docker://fedora:43"
          "fedora-42:docker://fedora:42"
          "linux:docker://ghcr.io/catthehacker/ubuntu:act-latest"
          "nix:host"
        ];

        settings = {
          log.level = "info";

          runner = {
            capacity = 8;  # Run up to 8 jobs concurrently
            timeout = "3h";
          };

          container = {
            network = "host";
            privileged = false;
            options = "-v /nix:/nix:ro";  # Share Nix store for nix-based jobs
            valid_volumes = [ "/nix" ];
          };

          cache = {
            enabled = true;
            dir = "/var/cache/gitea-runner";
          };
        };

        hostPackages = with pkgs; [
          bash
          coreutils
          curl
          gawk
          git
          git-lfs
          gnused
          jq
          nix
          nodejs
          podman
          skopeo
          tea
          wget
        ];
      };
    };
  };

  # Create cache directory
  systemd.tmpfiles.rules = [
    "d /var/cache/gitea-runner 0755 root root -"
  ];

  # Pre-pull runner images on boot so they're cached for jobs
  systemd.services.gitea-runner-pull-images = {
    description = "Pre-pull Gitea Actions runner container images";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "podman.service" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      echo "Pre-pulling runner images..."
      ${pkgs.podman}/bin/podman pull ghcr.io/catthehacker/ubuntu:act-latest || true
      ${pkgs.podman}/bin/podman pull ghcr.io/catthehacker/ubuntu:act-22.04 || true
      ${pkgs.podman}/bin/podman pull fedora:43 || true
      ${pkgs.podman}/bin/podman pull fedora:42 || true
      echo "Done pre-pulling images"
    '';
  };

  # Timer to refresh images weekly
  systemd.timers.gitea-runner-pull-images = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}
