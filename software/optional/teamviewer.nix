{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.jtekk.software.teamviewer.enable {
    # TeamViewer with XWayland support (fixes crashes on Wayland)
    services.teamviewer = {
      enable = true;
      package = pkgs.teamviewer.overrideAttrs (oldAttrs: {
        postFixup = (oldAttrs.postFixup or "") + ''
          wrapProgram $out/bin/teamviewer \
            --set QT_QPA_PLATFORM xcb \
            --set GDK_BACKEND x11
        '';
      });
    };
  };
}
