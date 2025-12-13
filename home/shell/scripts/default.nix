{ pkgs, ... }:

{
  imports = [
    ./close-all-windows.nix
    ./launch-steam.nix
    ./list-my-themes.nix
    ./open-terminal.nix
    ./screenshot-area.nix
    ./setup-fido2-ssh.nix
    ./ssh-bitwarden.nix
    ./unified-wallpaper.nix
    ./update-cursor.nix
  ];
}
