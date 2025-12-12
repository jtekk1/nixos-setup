{ pkgs, config, lib, ... }:

{
  programs.readline = {
    enable = true;

    variables = {
      "meta-flag" = "on";
      "input-meta" = "on";
      "output-meta" = "on";
      "convert-meta" = "off";
      "completion-ignore-case" = "on";
      "completion-prefix-display-length" = "2";
      "show-all-if-ambiguous" = "on";
      "show-all-if-unmodified" = "on";
      "mark-symlinked-directories" = "on";
      "match-hidden-files" = "off";
      "page-completions" = "off";
      "completion-query-items" = "200";
      "visible-stats" = "on";
      "skip-completed-text" = "on";
      "colored-stats" = "on";
    };
  };
}
