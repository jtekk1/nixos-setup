{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Window management
    bind=SUPER,q,killclient,
    bind=SUPER+SHIFT,q,forcekill

    # Focus navigation
    bind=SUPER,Left,focusdir,left
    bind=SUPER,Right,focusdir,right
    bind=SUPER,Up,focusdir,up
    bind=SUPER,Down,focusdir,down

    # Window switching (keep Alt+Tab for familiarity)
    bind=Alt,Tab,toggleoverview,
    bind=SUPER,Tab,focusstack,next
    bind=SUPER,u,focuslast

    # Window swapping
    bind=SUPER+SHIFT,Up,exchange_client,up
    bind=SUPER+SHIFT,Down,exchange_client,down
    bind=SUPER+SHIFT,Left,exchange_client,left
    bind=SUPER+SHIFT,Right,exchange_client,right

    # Smart move and resize
    bind=CTRL+SHIFT,Up,smartmovewin,up
    bind=CTRL+SHIFT,Down,smartmovewin,down
    bind=CTRL+SHIFT,Left,smartmovewin,left
    bind=CTRL+SHIFT,Right,smartmovewin,right
    bind=CTRL+ALT,Up,smartresizewin,up
    bind=CTRL+ALT,Down,smartresizewin,down
    bind=CTRL+ALT,Left,smartresizewin,left
    bind=CTRL+ALT,Right,smartresizewin,right

    # Window states
    bind=ALT,f,togglefullscreen,
    bind=SUPER+ALT,f,togglefakefullscreen,
    bind=SUPER,a,togglemaximizescreen,
    bind=SUPER,backslash,togglefloating,
    bind=SUPER,g,toggleglobal,
    bind=SUPER+ALT,o,toggleoverlay,
    bind=SUPER,i,minimized,
    bind=SUPER+ALT,i,restore_minimized

    # Cursor lock (for gaming)
    bind=SUPER+SHIFT,l,lock_cursor
    bind=SUPER+SHIFT,Escape,unlock_cursor

    # Gap control
    bind=SUPER+SHIFT,x,incgaps,10
    bind=SUPER+SHIFT,z,incgaps,-10
    bind=SUPER+SHIFT,r,togglegaps
  '';
}
