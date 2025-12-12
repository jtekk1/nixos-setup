{ config, lib, pkgs, ... }:

let integratedShelltools = [ "fzf" "zoxide" "atuin" ];
in {

  programs = lib.listToAttrs (map (name: {
    name = name;
    value = {
      enable = true;
      enableBashIntegration = true;
    };
  }) integratedShelltools);

  home.packages = with pkgs; [
    # shell tools
    bat
    coreutils
    eza
    fd
    lsof
    pciutils
    procps
    psmisc
    ripgrep
    rsync
    udiskie
    watchexec
    wget

    # TUI Apps
    dust
    dysk
    superfile

    # Dev Tools
    jq
    tldr
    tree-sitter
    glow
    md-tui
  ];
}
