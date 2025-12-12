{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Volume (using wpctl for better USB device compatibility)
    bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0
    bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    # Brightness
    bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl set +5%
    bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl set 5%-

    # Media keys (confirmed from wev output)
    bind=NONE,XF86AudioPlay,spawn,playerctl play-pause      # key: 172
    bind=NONE,XF86AudioStop,spawn,playerctl stop            # key: 174
    bind=NONE,XF86AudioNext,spawn,playerctl position 10+    # key: 171 (fast-forward)
    bind=NONE,XF86AudioPrev,spawn,playerctl position 10-    # key: 173 (rewind)
  '';
}
