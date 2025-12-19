"""
Key Bindings for QTile

Last Modified: 2025-12-18
By: JTekk
"""

from .core import core_binds
from .tui import tui_binds
from .webapps import webapp_binds
from .apps import app_binds
from .thirdparty import thirdparty_binds
from .layout import layout_binds
from .media import media_binds
from .windows import window_binds


key_binds = [
    *core_binds,
    *tui_binds,
    *webapp_binds,
    *app_binds,
    *thirdparty_binds,
    *layout_binds,
    *media_binds,
    *window_binds,
]
