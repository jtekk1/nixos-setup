{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Basic window rules
    windowrule=isfloating:1,title:Wiremix,width:800,height:600,isoverlay:1
    windowrule=isfloating:1,appid:blueberry;isoverlay:1
    windowrule=isfloating:1,appid:nm-connection-editor,isoverlay:1
    windowrule=isfloating:1,appid:xfce-polkit
    windowrule=isfloating:1,appid:steam,isoverlay:1,tag:6
    windowrule=animation_type_close:zoom,appid:Rofi
    windowrule=unfocused_opacity:0.85,focused_opacity:0.95,appid:kitty
    windowrule=unfocused_opacity:1.0,focused_opacity:1.0,appid:Google-chrome
  '';
} 

