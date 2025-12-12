{ config, pkgs, ... }:

{
  # ZFS Replication: Tank → Mini-me
  # Automated disaster recovery backups using ZFS send/receive
  # Runs daily at 3 AM to replicate critical datasets

  # Replication script
  systemd.services.zfs-replicate = {
    description = "ZFS Replication Tank → Mini-me";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    path = [ pkgs.zfs pkgs.openssh pkgs.gawk ];

    script = ''
      set -e

      REMOTE="192.168.0.250"  # mini-me IP address
      DATE=$(date +%Y%m%d-%H%M)
      SSH_OPTS="-o StrictHostKeyChecking=accept-new"

      echo "Starting ZFS replication at $(date)"

      # Function to replicate a dataset
      replicate_dataset() {
        local SOURCE=$1
        local TARGET=$2
        local SNAPSHOT="sync-$DATE"

        echo "Replicating $SOURCE to $REMOTE:$TARGET..."

        # Create snapshot
        ${pkgs.zfs}/bin/zfs snapshot -r "$SOURCE@$SNAPSHOT"

        # Find the most recent previous snapshot for incremental send
        PREV_SNAP=$(${pkgs.zfs}/bin/zfs list -t snapshot -o name -s creation "$SOURCE" | \
          ${pkgs.gawk}/bin/awk -F@ '/sync-/ {prev=$2} END {print prev}' | \
          ${pkgs.gawk}/bin/awk -v current="$SNAPSHOT" '$0 != current {print; exit}')

        # Send incremental or full snapshot
        if [ -n "$PREV_SNAP" ] && [ "$PREV_SNAP" != "$SNAPSHOT" ]; then
          echo "  Incremental from @$PREV_SNAP"
          ${pkgs.zfs}/bin/zfs send -R -i "$SOURCE@$PREV_SNAP" "$SOURCE@$SNAPSHOT" | \
            ssh $SSH_OPTS "$REMOTE" "${pkgs.zfs}/bin/zfs receive -F $TARGET"
        else
          echo "  Full replication (first run)"
          ${pkgs.zfs}/bin/zfs send -R "$SOURCE@$SNAPSHOT" | \
            ssh $SSH_OPTS "$REMOTE" "${pkgs.zfs}/bin/zfs receive -F $TARGET"
        fi

        echo "  Completed $SOURCE"
      }

      # Replicate both pools
      replicate_dataset "tank-fast" "mini-me-storage/tank-fast"
      replicate_dataset "tank-bulk" "mini-me-storage/tank-bulk"

      echo "ZFS replication completed successfully at $(date)"
    '';
  };

  # Timer to run replication daily at 6 AM
  systemd.timers.zfs-replicate = {
    description = "ZFS Replication Timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "06:00";
      Persistent = true;
      RandomizedDelaySec = "15m";  # Random delay to avoid exact 6 AM load
    };
  };
}
