{ config, pkgs, lib, ... }:

let
  # Mailrise package (not in nixpkgs, so we define it here)
  mailrise = pkgs.python3.pkgs.buildPythonApplication rec {
    pname = "mailrise";
    version = "1.4.0";
    format = "setuptools";

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-BKl5g4R9L5IrygMd9Vbi20iF2APpxSSfKxU25naPGTc=";
    };

    nativeBuildInputs = with pkgs.python3.pkgs; [
      setuptools
      setuptools-scm
    ];

    propagatedBuildInputs = with pkgs.python3.pkgs; [
      apprise
      aiosmtpd
      pyyaml
    ];

    doCheck = false;  # Skip tests
    pythonImportsCheck = [ "mailrise" ];

    meta = with lib; {
      description = "An SMTP gateway for Apprise notifications";
      homepage = "https://mailrise.xyz";
      license = licenses.mit;
    };
  };

  user = "mailrise";
  group = "mailrise";

  # Runtime config directory
  configDir = "/var/lib/mailrise";
  configFile = "${configDir}/mailrise.conf";

in
{
  # Mailrise SMTP gateway for notifications
  # Converts emails → Discord notifications via Apprise

  # Discord webhook secret
  sops.secrets."mailrise/discord_webhook" = {
    sopsFile = ../../secrets/common.yaml;
    owner = user;
    group = group;
  };

  # Create user and group
  users.users.${user} = {
    isSystemUser = true;
    group = group;
    description = "Mailrise SMTP gateway user";
  };

  users.groups.${group} = {};

  # Systemd service
  systemd.services.mailrise = {
    description = "Mailrise SMTP notification gateway";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    # Generate config file at startup with secret
    preStart = ''
      mkdir -p ${configDir}

      DISCORD_WEBHOOK=$(cat ${config.sops.secrets."mailrise/discord_webhook".path})

      cat > ${configFile} <<EOF
# Mailrise SMTP → Discord notifications
# Deployed on: mini-me

configs:
  # Send to: alerts@mailrise.xyz
  alerts:
    urls:
      - $DISCORD_WEBHOOK

  # Notification types (changes icon color):
  # alerts.success@mailrise.xyz (green)
  # alerts.warning@mailrise.xyz (yellow)
  # alerts.failure@mailrise.xyz (red)

listen:
  host: 0.0.0.0
  port: 8025
EOF

      chmod 600 ${configFile}
    '';

    serviceConfig = {
      Type = "simple";
      User = user;
      Group = group;
      ExecStart = "${mailrise}/bin/mailrise ${configFile}";
      Restart = "on-failure";
      RestartSec = "5s";

      # State directory for config file
      StateDirectory = "mailrise";

      # Hardening
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
    };
  };

  # Open firewall for SMTP connections from LAN
  networking.firewall.allowedTCPPorts = [ 8025 ];
}
