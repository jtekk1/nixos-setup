{ ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";
    BAT_THEME = "ansi";
    BROWSER = "chromium";
    TERMINAL = "foot";

    # FZF configuration
    FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    FZF_CTRL_T_COMMAND = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    FZF_ALT_C_COMMAND = "fd --type d --strip-cwd-prefix --hidden --follow --exclude .git";
    FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";
  };
}
