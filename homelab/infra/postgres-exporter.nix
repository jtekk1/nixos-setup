{ config, lib, pkgs, ... }:

{
  # PostgreSQL Prometheus exporter
  # Monitors PostgreSQL databases for metrics collection

  services.prometheus.exporters.postgres = {
    enable = true;
    port = 9187;

    # Run as postgres user to access local PostgreSQL socket
    runAsLocalSuperUser = true;

    # Monitor all databases on this host
    # The exporter auto-discovers databases
  };

  # Create a monitoring user with appropriate permissions
  services.postgresql = {
    ensureUsers = [{
      name = "postgres_exporter";
      ensureDBOwnership = false;
    }];
  };

  # Grant monitoring permissions to the exporter user
  systemd.services.postgresql.postStart = lib.mkAfter ''
    $PSQL -tAc 'GRANT pg_monitor TO postgres_exporter' || true
  '';

  # Firewall - allow Prometheus to scrape the exporter
  networking.firewall.allowedTCPPorts = [ 9187 ];
}
