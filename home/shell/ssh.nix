{ pkgs, osConfig, ... }:

let
  networkConfig = import ../../network-config.nix;
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        compression = false;
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        identitiesOnly = false;
      };

      "mini-me" = {
        hostname = networkConfig.hosts.mini-me.ip;
        user = "jtekk";
        identityFile = "~/.ssh/nixos-deploy";
        identitiesOnly = true;
      };

      "beelink" = {
        hostname = networkConfig.hosts.beelink.ip;
        user = "jtekk";
        identityFile = "~/.ssh/nixos-deploy";
        identitiesOnly = true;
      };

      "tank" = {
        hostname = networkConfig.hosts.tank.ip;
        user = "jtekk";
        identityFile = "~/.ssh/nixos-deploy";
        identitiesOnly = true;
      };

      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ghkey";
        identitiesOnly = true;
      };

      "git.jtekk.dev" = {
        hostname = "git.jtekk.dev";
        user = "gitea";
        identityFile = "~/.ssh/gitea";
        identitiesOnly = true;
      };

      "${networkConfig.hosts.mini-me.ip}" = {
        user = "jtekk";
        identityFile = "~/.ssh/nixos-deploy";
        identitiesOnly = true;
      };
      "${networkConfig.hosts.beelink.ip}" = {
        user = "jtekk";
        identityFile = "~/.ssh/nixos-deploy";
        identitiesOnly = true;
      };
      "${networkConfig.hosts.tank.ip}" = {
        user = "jtekk";
        identityFile = "~/.ssh/nixos-deploy";
        identitiesOnly = true;
      };
    };

    extraConfig = ''
      # FIDO2 keys (these work independently of GPG agent)
      IdentityFile ~/.ssh/fido2
      IdentityFile ~/.ssh/fido2_ecdsa
      IdentityFile ~/.ssh/ghkey

      # Fall back to GPG agent for other keys
      IdentityAgent ~/.gnupg/S.gpg-agent.ssh
    '';
  };

  # SSH agent is provided by Bitwarden desktop
  # Use ssh-use-bitwarden / ssh-use-default to switch agents
  services.ssh-agent.enable = true;
}
