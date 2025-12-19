"""
Key Bindings for the apps

Last Modified: 2025-12-18
By: JTekk
"""

from libqtile.config import Key
from libqtile.lazy import lazy
from . import config as CFG


mod = CFG.mod

app_binds = [
    Key(mod, "slash", lazy.spawn("bitwarden"), desc="Bitwarden"),
    Key(mod, "b", CFG.tui("btop"), desc="Btop on terminal"),
    Key(mod, "c", lazy.spawn("cursor"), desc="Cursor Code Editor"),
    Key(mod, "f", lazy.spawn("nautilus"), desc="Nautilus File Browser"),
    Key(mod, "m", lazy.spawn("spotify"), desc="Spotify"),
    Key(mod, "n", CFG.tui("nvim"), desc="Neovim Editor"),
    Key(mod, "o", lazy.spawn("obsidian"), desc="Obsidian Editor"),
    Key(mod, "t", lazy.spawn("chromium"), desc="Chromium Web Browser"),
    Key(mod, "x", CFG.tui("claude"), desc="Claude CLI"),
]
