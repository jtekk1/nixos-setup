{ config, ... }:

{
  home.sessionPath = [
    "${config.home.homeDirectory}/AppImages"
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/bin"
    "${config.home.homeDirectory}/scripts"
  ];
}
