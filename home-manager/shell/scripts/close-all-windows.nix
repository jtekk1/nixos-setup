{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "cmd-close-all-windows" ''
      # Close all open windows using mango's mmsg IPC
      # Get list of windows and close each one
      mmsg -d "close_all_windows"

      # Move to first workspace
      mmsg -d "workspace,1"
    '')
  ];
}
