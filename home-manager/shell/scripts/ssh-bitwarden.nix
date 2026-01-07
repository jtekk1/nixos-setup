{ pkgs, ... }:

{
  # Script to switch SSH agent to Bitwarden (when YubiKey not available)
  home.file.".local/bin/ssh-use-bitwarden" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Switch to Bitwarden SSH agent for this session
      # Usage: eval "$(ssh-use-bitwarden)"

      BITWARDEN_SOCK="$HOME/.bitwarden-ssh-agent.sock"

      if [ -S "$BITWARDEN_SOCK" ]; then
        echo "export SSH_AUTH_SOCK=\"$BITWARDEN_SOCK\""
      else
        echo "echo 'Error: Bitwarden SSH agent socket not found'" >&2
        echo "echo 'Make sure Bitwarden desktop is running with SSH agent enabled'" >&2
        echo "false"
      fi
    '';
  };

  # Script to switch back to default SSH agent
  home.file.".local/bin/ssh-use-default" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Switch back to default SSH agent (systemd ssh-agent service)
      # Usage: eval "$(ssh-use-default)"

      DEFAULT_SOCK="$XDG_RUNTIME_DIR/ssh-agent"

      if [ -S "$DEFAULT_SOCK" ]; then
        echo "export SSH_AUTH_SOCK=\"$DEFAULT_SOCK\""
      else
        echo "echo 'Error: Default SSH agent not running'" >&2
        echo "false"
      fi
    '';
  };

  # Script to check current SSH agent status
  home.file.".local/bin/ssh-agent-status" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Show current SSH agent status

      echo "Current SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
      echo ""

      if [[ "$SSH_AUTH_SOCK" == *"bitwarden"* ]]; then
        echo "Agent: Bitwarden"
      elif [[ "$SSH_AUTH_SOCK" == *"keyring"* ]]; then
        echo "Agent: GNOME Keyring"
      elif [[ "$SSH_AUTH_SOCK" == *"gpg"* ]]; then
        echo "Agent: GPG Agent"
      else
        echo "Agent: ssh-agent (default)"
      fi

      echo ""
      echo "Available keys:"
      ssh-add -l 2>/dev/null || echo "  (none or agent not running)"
    '';
  };
}
