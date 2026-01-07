{ config, lib, pkgs, theme ? "neuro-fusion", ... }:

{
  home.username = "jtekk";
  home.homeDirectory = lib.mkForce "/home/jtekk";
  home.stateVersion = "25.11";
}
