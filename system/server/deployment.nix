# Remote access and deployment configuration
# SSH, sudo rules for Colmena, and trusted users

{ config, pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users.jtekk.openssh.authorizedKeys.keyFiles = [ ../../keys/jtekk.pub ];
  users.users.jtekk.extraGroups = [ "wheel" ];

  # Passwordless sudo for NixOS activation and service management
  # Note: Colmena runs nix-env to update profile, then switch-to-configuration
  security.sudo.extraRules = [{
    users = [ "jtekk" ];
    commands = [
      {
        command = "/run/current-system/sw/bin/nix-env";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/nix/store/*/bin/nix-env";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/switch-to-configuration";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/nix/store/*/bin/switch-to-configuration";
        options = [ "NOPASSWD" ];
      }
      # Scoped systemctl - only restart/start/stop/reload/daemon-reload/status
      {
        command = "/run/current-system/sw/bin/systemctl restart *";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/systemctl start *";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/systemctl stop *";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/systemctl reload *";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/systemctl daemon-reload";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/systemctl status *";
        options = [ "NOPASSWD" ];
      }
    ];
  }];

  # Allow jtekk to use Nix for deployments
  nix.settings.trusted-users = [ "root" "jtekk" ];
}
