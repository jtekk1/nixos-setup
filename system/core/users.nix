{ config, lib, pkgs, ... }:

{
  users.users.jtekk = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "seat"
      "render"
      "video"
    ];
    shell = pkgs.bash;
  };
}
