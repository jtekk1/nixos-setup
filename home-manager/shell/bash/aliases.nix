{ ... }:

{
  programs.bash.shellAliases = {
    # File system
    ls = "eza -lh --group-directories-first --icons=auto";
    lsa = "ls -a";
    lt = "eza --tree --level=2 --long --icons --git";
    lta = "lt -a";
    ff = ''fzf --preview "bat --style=numbers --color=always {}"'';
    cd = "zd";

    # Directories
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # Compression
    decompress = "tar -xzf";

    # Other
    btop = ''LC_NUMERIC="en_US.UTF-8" btop'';
    cat = "bat";

    # SSH agent switching
    ssh-use-bitwarden = ''eval "$($HOME/.local/bin/ssh-use-bitwarden)" && ssh-agent-status'';
    ssh-use-default = ''eval "$($HOME/.local/bin/ssh-use-default)" && ssh-agent-status'';
  };
}
