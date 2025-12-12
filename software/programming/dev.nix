{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    claude-code
    gemini-cli
    crush
    open-interpreter
    neovim
    lua53Packages.luarocks
  ];
}
