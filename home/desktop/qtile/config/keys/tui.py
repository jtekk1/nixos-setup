"""
Key Bindings for the TUIs

Last Modified: 2025-12-18
By: JTekk
"""

from libqtile.config import Key
from libqtile.lazy import lazy
from . import config as CFG


tui_binds = [
    Key(CFG.mod, "Return", lazy.spawn(CFG.FOOT), desc="Spawn Foot"),
    Key(CFG.mod_shift, "Return", lazy.spawn(CFG.KITTY), desc="Spawn Kitty"),
]
