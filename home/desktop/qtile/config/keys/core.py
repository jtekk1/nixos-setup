"""
Key Bindings for core items

Last Modified: 2025-12-18
By: JTekk
"""

from libqtile.config import Key
from libqtile.lazy import lazy
from . import config as CFG


core_binds = [
    Key(CFG.mod_ctrl, "r", lazy.reload_config(), desc="Reload config"),
    Key(CFG.mod_alt, "m", lazy.shutdown(), desc="Shutdown QTile"),
]
