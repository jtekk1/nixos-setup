{ pkgs, ... }:

{
  imports = [
    ./close-all-windows.nix
    ./dpms-control.nix
    ./launch-steam.nix
    ./list-my-themes.nix
    ./open-terminal.nix
    ./screenshot-area.nix
    ./setup-fido2-ssh.nix
    ./ssh-bitwarden.nix
    ./toggle-sunset.nix
    ./update-cursor.nix
  ];
}
