"""
Key Bindings for Media Controls (volume, brightness, playback)

Last Modified: 2025-12-18
By: JTekk
"""

from libqtile.config import Key
from libqtile.lazy import lazy


media_binds = [
    # ==================== Volume Control ====================
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc="Volume down"),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Mute toggle"),

    # ==================== Brightness Control ====================
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%"), desc="Brightness up"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-"), desc="Brightness down"),

    # ==================== Media Playback ====================
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Play/Pause"),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop"), desc="Stop"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl position 10+"), desc="Seek forward 10s"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl position 10-"), desc="Seek backward 10s"),
]
