{ pkgs, config, ... }:

let
  osdclient = ''swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"'';
in {
  wayland.windowManager.hyprland.settings = {
    bindl = [
      # Media playback controls
      ", XF86AudioNext, exec, ${osdclient} --playerctl next"
      ", XF86AudioPause, exec, ${osdclient} --playerctl play-pause"
      ", XF86AudioPlay, exec, ${osdclient} --playerctl play-pause"
      ", XF86AudioPrev, exec, ${osdclient} --playerctl previous"
    ];

    bindel = [
      # Audio volume controls
      ", XF86AudioRaiseVolume, exec, ${osdclient} --output-volume raise"
      ", XF86AudioLowerVolume, exec, ${osdclient} --output-volume lower"
      ", XF86AudioMute, exec, ${osdclient} --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, ${osdclient} --input-volume mute-toggle"

      # Brightness controls
      ", XF86MonBrightnessUp, exec, ${osdclient} --brightness raise"
      ", XF86MonBrightnessDown, exec, ${osdclient} --brightness lower"

      # Fine-grained controls with ALT
      "ALT, XF86AudioRaiseVolume, exec, ${osdclient} --output-volume +1"
      "ALT, XF86AudioLowerVolume, exec, ${osdclient} --output-volume -1"
      "ALT, XF86MonBrightnessUp, exec, ${osdclient} --brightness +1"
      "ALT, XF86MonBrightnessDown, exec, ${osdclient} --brightness -1"
    ];
  };
}
