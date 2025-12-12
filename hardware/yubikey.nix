{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    pam_u2f
    libfido2
    yubioath-flutter
  ];

  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [
    yubikey-personalization
    libfido2
  ];

  security.pam.services.sudo = {
    u2fAuth = true;
  };

  programs.ssh.startAgent = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.gnupg/S.gpg-agent.ssh
  '';
}
