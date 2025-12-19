"""
Key Bindings for 3rd Party Tools (screenshots, launchers, etc.)

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
ctrl_alt = ["control", "mod1"]
ctrl_shift = CFG.ctrl_shift
ctrl_alt_shift = ["control", "mod1", "shift"]

thirdparty_binds = [
    # ==================== Scratchpad ====================
    Key(mod, "minus", lazy.group["scratchpad"].dropdown_toggle("term"), desc="Toggle scratchpad"),

    # ==================== Screenshots ====================
    Key([], "Print", lazy.spawn("grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"), desc="Screenshot full"),
    Key(ctrl_alt, "4", lazy.spawn("grim - | wl-copy"), desc="Screenshot to clipboard"),
    Key(ctrl_shift, "4", lazy.spawn("~/.local/bin/screenshot-area --clipboard"), desc="Screenshot area to clipboard"),
    Key(ctrl_alt, "a", lazy.spawn('grim -g "$(slurp -b \'#2E2A1E55\' -c \'#88c0d0ff\')" -t ppm - | satty -f -'), desc="Screenshot area with satty"),

    # ==================== Launchers ====================
    Key(mod, "space", lazy.spawn("wofi --show drun"), desc="App launcher"),
    Key(mod, "r", lazy.spawn("wofi --show run"), desc="Run command"),
    Key(mod, "v", lazy.spawn("~/.local/bin/wofi-clipboard-menu"), desc="Clipboard menu"),

    # ==================== Lock Screen ====================
    Key(mod_ctrl, "Escape", lazy.spawn("swaylock"), desc="Lock screen"),

    # ==================== Notifications ====================
    Key(mod, "BackSpace", lazy.spawn("swaync-client -t"), desc="Toggle notification center"),
    Key(mod_shift, "BackSpace", lazy.spawn("swaync-client -C"), desc="Clear notifications"),

    # ==================== Power Menu ====================
    Key(mod, "Escape", lazy.spawn("~/.local/bin/wofi-power-menu"), desc="Power menu"),

    # ==================== Wallpaper ====================
    Key(mod_alt, "w", lazy.spawn("unified-wallpaper"), desc="Next wallpaper"),
    Key(mod_alt, "p", lazy.spawn("unified-wallpaper --prev"), desc="Previous wallpaper"),
    Key(["mod1", "mod4", "shift"], "w", lazy.spawn("unified-wallpaper --random"), desc="Random wallpaper"),
    Key(ctrl_alt_shift, "t", lazy.spawn("unified-wallpaper --time"), desc="Time-based wallpaper"),
]
