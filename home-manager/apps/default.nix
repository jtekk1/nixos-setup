{ pkgs, ... }:

{
  imports = [ ./foot.nix ./kitty.nix ./webapps.nix ./nixvim.nix ./tui-launchers.nix ];
}
