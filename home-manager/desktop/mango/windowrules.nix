{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Basic window rules - TUI apps launched from waybar with foot -T
    windowrule=isfloating:1,title:WIREMIX,width:800,height:600,isoverlay:1
    windowrule=isfloating:1,title:BTUI,width:600,height:400,isoverlay:1
    windowrule=isfloating:1,title:BTOP,width:1200,height:800,isoverlay:1
    windowrule=isfloating:1,title:GDU,width:1000,height:700,isoverlay:1
    windowrule=isfloating:1,title:IMPALA,width:800,height:500,isoverlay:1
    windowrule=isfloating:1,title:superfile,width:1000,height:700,isoverlay:1
    windowrule=isfloating:1,appid:polkit-gnome-authentication-agent-1,isoverlay:1
    windowrule=isfloating:1,appid:steam,isoverlay:1,tag:6
    windowrule=animation_type_close:zoom,appid:Rofi
    windowrule=animation_type_open:zoom,appid:Rofi
    windowrule=unfocused_opacity:0.85,focused_opacity:0.95,appid:kitty
    windowrule=unfocused_opacity:0.85,focused_opacity:0.95,appid:foot
    windowrule=unfocused_opacity:0.85,focused_opacity:0.95,appid:ghostty
    windowrule=unfocused_opacity:1.0,focused_opacity:1.0,appid:Google-chrome

    # Layer rules
    layerrule=layer_name:wofi,animation_type_open:zoom,animation_type_close:zoom

    # Tag rules (per-tag default layouts)
    tagrule=id:1,layout_name:tile
    tagrule=id:2,layout_name:center_tile
    tagrule=id:3,layout_name:scroller
    tagrule=id:4,layout_name:grid
    tagrule=id:5,layout_name:tgmix
    tagrule=id:6,layout_name:tgmix
    tagrule=id:7,layout_name:tgmix
    tagrule=id:8,layout_name:tgmix
    tagrule=id:9,layout_name:tgmix
  '';
}

