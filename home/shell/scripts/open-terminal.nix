{ pkgs, config, ... }:

{
  home.file.".local/bin/open-terminal" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Get the current active window's PID
      terminal_pid=$(hyprctl activewindow -j | jq -r '.pid // 0')

      # If no PID or it's 0, return HOME
      if [[ "$terminal_pid" == "0" ]] || [[ -z "$terminal_pid" ]]; then
        echo "$HOME"
        exit 0
      fi

      # Find all child processes of the terminal
      children=$(pgrep -P "$terminal_pid" 2>/dev/null)

      # Try to find a shell process (bash, zsh, fish, sh)
      for child_pid in $children; do
        # Get the command name of this process
        cmd=$(ps -p "$child_pid" -o comm= 2>/dev/null)

        # Check if it's a known shell
        if [[ "$cmd" =~ ^(bash|zsh|fish|sh)$ ]]; then
          # Found a shell, get its CWD
          cwd=$(readlink -f "/proc/$child_pid/cwd" 2>/dev/null)
          if [[ -n "$cwd" ]] && [[ -d "$cwd" ]]; then
            echo "$cwd"
            exit 0
          fi
        fi
      done

      # If no shell found, try the first child process
      first_child=$(echo "$children" | head -n1)
      if [[ -n "$first_child" ]]; then
        cwd=$(readlink -f "/proc/$first_child/cwd" 2>/dev/null)
        if [[ -n "$cwd" ]] && [[ -d "$cwd" ]]; then
          echo "$cwd"
          exit 0
        fi
      fi

      # Default to HOME
      echo "$HOME"
    '';
  };
}