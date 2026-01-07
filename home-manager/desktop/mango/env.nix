{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Environment variables
    env=XCURSOR_SIZE,24
    env=XCURSOR_THEME,Yaru
    env=GTK_THEME,Yaru-dark
    env=GTK_IM_MODULE,wayland
    env=GLFW_IM_MODULE,ibus
    env=QT_QPA_PLATFORMTHEME,gtk3
    env=QT_AUTO_SCREEN_SCALE_FACTOR,1
    env=QT_WAYLAND_FORCE_DPI,120
    env=QT_QPA_PLATFORM,wayland
    env=GDK_BACKEND,wayland
  '';
}
