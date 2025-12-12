{ pkgs, config, ... }:

let
  # Webapp shortcuts using centralized webapp module
  wa = config.programs.webapps.apps;
  webapp = url: "chromium --app=${url}";
in {
  wayland.windowManager.mango.settings = ''
    # App shortcuts
    bind=SUPER,slash,spawn,bitwarden
    bind=SUPER,b,spawn,foot btop
    bind=SUPER,c,spawn,cursor
    bind=SUPER,f,spawn,cosmic-files
    bind=SUPER+SHIFT,f,spawn,kitty -e superfile
    bind=SUPER,m,spawn,spotify
    #bind=SUPER,n,spawn,kitty nvim
    bind=SUPER,o,spawn,obsidian
    bind=SUPER,t,spawn,chromium
    bind=SUPER,x,spawn,foot claude

    # Webapp shortcuts (managed by programs.webapps module)
    bind=SUPER+SHIFT,a,spawn,${webapp wa.audible.url}
    bind=SUPER+SHIFT,c,spawn,${webapp wa.claude.url}
    bind=SUPER+SHIFT,g,spawn,${webapp wa.gemini.url}
    bind=SUPER+SHIFT,h,spawn,${webapp wa.hbomax.url}
    bind=SUPER+SHIFT,i,spawn,${webapp wa.instagram.url}
    bind=SUPER+SHIFT,m,spawn,${webapp wa.zohomail.url}
    bind=SUPER+SHIFT,n,spawn,${webapp wa.netflix.url}
    bind=SUPER+SHIFT,o,spawn,${webapp wa.chatgpt.url}
    bind=SUPER+SHIFT,t,spawn,${webapp wa.teams.url}
    bind=SUPER+SHIFT,u,spawn,${webapp wa.upwork.url}
    bind=SUPER+SHIFT,y,spawn,${webapp wa.youtube.url}

    # Wallpaper management
    bind=SUPER+ALT,w,spawn,unified-wallpaper
    bind=SUPER+ALT,p,spawn,unified-wallpaper --prev
    bind=SUPER+ALT+SHIFT,w,spawn,unified-wallpaper --random
    bind=CTRL+ALT+SHIFT,t,spawn,unified-wallpaper --time
  '';
}
