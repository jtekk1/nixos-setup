{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "JTekk";
        email = "joaquin@jtekk.dev";
      };
    };
  };
}
