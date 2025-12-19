"""
Key Bindings for Window Management

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
ctrl_shift = CFG.ctrl_shift
ctrl_alt = ["control", "mod1"]

window_binds = [
    # ==================== Window Actions ====================
    Key(mod, "q", lazy.window.kill(), desc="Kill window"),
    Key(mod_shift, "q", lazy.window.kill(), desc="Force kill window"),

    # ==================== Focus Navigation ====================
    Key(mod, "Left", lazy.layout.left(), desc="Focus left"),
    Key(mod, "Right", lazy.layout.right(), desc="Focus right"),
    Key(mod, "Up", lazy.layout.up(), desc="Focus up"),
    Key(mod, "Down", lazy.layout.down(), desc="Focus down"),
    Key(mod, "h", lazy.layout.left(), desc="Focus left (vim)"),
    Key(mod, "l", lazy.layout.right(), desc="Focus right (vim)"),
    Key(mod, "k", lazy.layout.up(), desc="Focus up (vim)"),
    Key(mod, "j", lazy.layout.down(), desc="Focus down (vim)"),

    # ==================== Window Switching ====================
    Key(["mod1"], "Tab", lazy.group.next_window(), desc="Next window"),
    Key(mod, "u", lazy.group.prev_window(), desc="Previous window"),

    # ==================== Window Swapping ====================
    Key(mod_shift, "Up", lazy.layout.shuffle_up(), desc="Swap up"),
    Key(mod_shift, "Down", lazy.layout.shuffle_down(), desc="Swap down"),
    Key(mod_shift, "Left", lazy.layout.shuffle_left(), desc="Swap left"),
    Key(mod_shift, "Right", lazy.layout.shuffle_right(), desc="Swap right"),
    Key(mod_shift, "h", lazy.layout.shuffle_left(), desc="Swap left (vim)"),
    Key(mod_shift, "l", lazy.layout.shuffle_right(), desc="Swap right (vim)"),
    Key(mod_shift, "k", lazy.layout.shuffle_up(), desc="Swap up (vim)"),
    Key(mod_shift, "j", lazy.layout.shuffle_down(), desc="Swap down (vim)"),

    # ==================== Window Resizing ====================
    Key(ctrl_alt, "Up", lazy.layout.grow_up(), desc="Grow up"),
    Key(ctrl_alt, "Down", lazy.layout.grow_down(), desc="Grow down"),
    Key(ctrl_alt, "Left", lazy.layout.grow_left(), desc="Grow left"),
    Key(ctrl_alt, "Right", lazy.layout.grow_right(), desc="Grow right"),
    Key(mod_ctrl, "h", lazy.layout.grow_left(), desc="Grow left (vim)"),
    Key(mod_ctrl, "l", lazy.layout.grow_right(), desc="Grow right (vim)"),
    Key(mod_ctrl, "k", lazy.layout.grow_up(), desc="Grow up (vim)"),
    Key(mod_ctrl, "j", lazy.layout.grow_down(), desc="Grow down (vim)"),

    # ==================== Window States ====================
    Key(["mod1"], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key(mod, "a", lazy.window.toggle_maximize(), desc="Toggle maximize"),
    Key(mod, "backslash", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key(mod_shift, "space", lazy.window.toggle_floating(), desc="Toggle floating (alt)"),
    Key(mod, "i", lazy.window.toggle_minimize(), desc="Toggle minimize"),
    Key(mod_alt, "i", lazy.group.unminimize_all(), desc="Restore minimized"),
]
