{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Layout control
    bind=SUPER,s,zoom,
    bind=SUPER,n,switch_layout,

    # Layouts
    bind=SUPER+CTRL,t,setlayout,tile
    bind=SUPER+CTRL,x,setlayout,tgmix
    bind=SUPER+CTRL,s,setlayout,scroller
    bind=SUPER+CTRL,m,setlayout,monocle
    bind=SUPER+CTRL,g,setlayout,grid
    bind=SUPER+CTRL,d,setlayout,deck
    bind=SUPER+CTRL,c,setlayout,center_tile
    bind=SUPER+CTRL,e,setlayout,vertical_scroller
    bind=SUPER+CTRL,v,setlayout,vertical_tile

    # Master/stack control
    bind=SUPER+ALT,e,incnmaster,1
    bind=SUPER+ALT,t,incnmaster,-1
    bind=ALT+SUPER,h,setmfact,-0.05
    bind=ALT+SUPER,l,setmfact,+0.05
    bind=ALT+SUPER,k,setsmfact,-0.05
    bind=ALT+SUPER,j,setsmfact,+0.05

    # Proportion control
    bind=SUPER+SHIFT,e,set_proportion,0.33
    bind=SUPER+ALT,x,switch_proportion_preset,

    # Workspace/Tag navigation
    bind=SUPER,1,view,1,0
    bind=SUPER,2,view,2,0
    bind=SUPER,3,view,3,0
    bind=SUPER,4,view,4,0
    bind=SUPER,5,view,5,0
    bind=SUPER,6,view,6,0
    bind=SUPER,7,view,7,0
    bind=SUPER,8,view,8,0
    bind=SUPER,9,view,9,0

    # Move window to tag
    bind=SUPER+SHIFT,1,tag,1,0
    bind=SUPER+SHIFT,2,tag,2,0
    bind=SUPER+SHIFT,3,tag,3,0
    bind=SUPER+SHIFT,4,tag,4,0
    bind=SUPER+SHIFT,5,tag,5,0
    bind=SUPER+SHIFT,6,tag,6,0
    bind=SUPER+SHIFT,7,tag,7,0
    bind=SUPER+SHIFT,8,tag,8,0
    bind=SUPER+SHIFT,9,tag,9,0

    # Toggle tag view
    bind=CTRL+SUPER,1,toggleview,1
    bind=CTRL+SUPER,2,toggleview,2
    bind=CTRL+SUPER,3,toggleview,3
    bind=CTRL+SUPER,4,toggleview,4
    bind=CTRL+SUPER,5,toggleview,5
    bind=CTRL+SUPER,6,toggleview,6
    bind=CTRL+SUPER,7,toggleview,7
    bind=CTRL+SUPER,8,toggleview,8
    bind=CTRL+SUPER,9,toggleview,9

    # Toggle tag
    bind=SUPER+ALT,1,toggletag,1
    bind=SUPER+ALT,2,toggletag,2
    bind=SUPER+ALT,3,toggletag,3
    bind=SUPER+ALT,4,toggletag,4
    bind=SUPER+ALT,5,toggletag,5
    bind=SUPER+ALT,6,toggletag,6
    bind=SUPER+ALT,7,toggletag,7
    bind=SUPER+ALT,8,toggletag,8
    bind=SUPER+ALT,9,toggletag,9

    # Workspace navigation
    bind=SUPER+CTRL,Left,viewtoleft,0
    bind=SUPER+CTRL,Right,viewtoright,0
    bind=CTRL,Left,viewtoleft_have_client,0
    bind=CTRL,Right,viewtoright_have_client,0
    bind=CTRL+SUPER+SHIFT,Left,tagtoleft,0
    bind=CTRL+SUPER+SHIFT,Right,tagtoright,0
    
    # monitor focus
    bind=super+alt,left,focusmon,left
    bind=super+alt,right,focusmon,right
    bind=super+alt,up,focusmon,up
    bind=super+alt,down,focusmon,down

    # move to monitor
    bind=super+alt+shift,left,tagmon,left
    bind=super+alt+shift,right,tagmon,right
    bind=super+alt+shift,up,tagmon,up
    bind=super+alt+shift,down,tagmon,down
  ''; 
}
    
