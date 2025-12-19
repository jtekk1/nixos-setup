"""
Config help for Key Bindings

Last Modified: 2025-12-18
By: JTekk
"""

import json
from types import SimpleNamespace
from libqtile.lazy import LazyCall, lazy


# Modifier key (mod4 = Super/Windows key)
MOD = "mod4"
KITTY = "kitty"
FOOT = "foot"
TERMINAL = FOOT

mod = [MOD]
mod_ctrl = [MOD, "control"]
mod_alt = [MOD, "alt"]
mod_shift = [MOD, "shift"]
ctrl_shift = ["control", "shift"]


def webapp(url: str) -> LazyCall:
    "Opens Webapp by the URL submitted"
    return lazy.spawn(f"chromium --app={url}")


def tui(cmd: str) -> LazyCall:
    "Opens TUI via declared Terminal"
    return lazy.spawn(f"{TERMINAL} {cmd}")
