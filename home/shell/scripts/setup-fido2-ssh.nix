{ config, ... }:

{
  home.file.".local/bin/setup-fido2-ssh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -e

      echo "Setting up FIDO2 SSH keys with YubiKey"
      echo "======================================="
      echo ""
      echo "Make sure your YubiKey is plugged in!"
      echo ""

      mkdir -p ~/.ssh
      chmod 700 ~/.ssh

      # Generate ed25519-sk key (recommended)
      if [ ! -f ~/.ssh/fido2 ]; then
        echo "Generating ED25519-SK FIDO2 key..."
        echo "Touch your YubiKey when prompted!"
        ssh-keygen -t ed25519-sk -f ~/.ssh/fido2 -C "${config.home.username}@yubikey-fido2"
      else
        echo "FIDO2 key already exists at ~/.ssh/fido2"
      fi

      # Optionally generate ecdsa-sk for compatibility
      if [ ! -f ~/.ssh/fido2_ecdsa ]; then
        read -p "Generate ECDSA-SK key for compatibility? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          echo "Generating ECDSA-SK FIDO2 key..."
          echo "Touch your YubiKey when prompted!"
          ssh-keygen -t ecdsa-sk -f ~/.ssh/fido2_ecdsa -C "${config.home.username}@yubikey-ecdsa"
        fi
      else
        echo "ECDSA-SK key already exists at ~/.ssh/fido2_ecdsa"
      fi

      echo ""
      echo "Setup complete! Your public keys:"
      echo "================================="
      [ -f ~/.ssh/fido2.pub ] && cat ~/.ssh/fido2.pub
      [ -f ~/.ssh/fido2_ecdsa.pub ] && cat ~/.ssh/fido2_ecdsa.pub
      echo ""
      echo "Add these public keys to GitHub/GitLab/etc."
    '';
  };
}
