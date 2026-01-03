{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    claude-code
    # gemini-cli # temporarily disabled due to npm deps hash mismatch
    crush
    open-interpreter
    neovim
    lua53Packages.luarocks
  ];
}
