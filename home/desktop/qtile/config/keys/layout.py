"""
Key Bindings for Layout and Workspace Control

Last Modified: 2025-12-18
By: JTekk
"""

from libqtile.config import Key
from libqtile.lazy import lazy
from . import config as CFG


mod = CFG.mod
mod_ctrl = CFG.mod_ctrl
mod_alt = CFG.mod_alt
mod_shift = CFG.mod_shift

layout_binds = [
    # ==================== Layout Control ====================
    Key(mod, "s", lazy.layout.toggle_split(), desc="Toggle split"),
    Key(mod, "Tab", lazy.next_layout(), desc="Next layout"),

    # ==================== Master/Stack Control ====================
    Key(mod_alt, "e", lazy.layout.grow_main(), desc="Grow main"),
    Key(mod_alt, "t", lazy.layout.shrink_main(), desc="Shrink main"),
    Key(mod_alt, "h", lazy.layout.shrink(), desc="Shrink window"),
    Key(mod_alt, "l", lazy.layout.grow(), desc="Grow window"),
    Key(mod_alt, "k", lazy.layout.shuffle_up(), desc="Shuffle up"),
    Key(mod_alt, "j", lazy.layout.shuffle_down(), desc="Shuffle down"),
    Key(mod, "n", lazy.layout.normalize(), desc="Normalize layout"),

    # ==================== Monitor Focus ====================
    Key(mod_alt, "Left", lazy.prev_screen(), desc="Focus previous monitor"),
    Key(mod_alt, "Right", lazy.next_screen(), desc="Focus next monitor"),

    # ==================== Move Window to Monitor ====================
    Key(["mod1", "mod4", "shift"], "Left", lazy.window.toscreen(0), desc="Move to monitor 0"),
    Key(["mod1", "mod4", "shift"], "Right", lazy.window.toscreen(1), desc="Move to monitor 1"),
]

# ==================== Workspace Navigation (via loop) ====================
for i in "123456789":
    layout_binds.extend([
        Key(mod, i, lazy.group[i].toscreen(), desc=f"Go to workspace {i}"),
        Key(mod_shift, i, lazy.window.togroup(i, switch_group=False), desc=f"Move to workspace {i}"),
    ])
