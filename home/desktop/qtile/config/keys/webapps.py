"""
Key Bindings for the webapps

Last Modified: 2025-12-18
By: JTekk
"""

import json
from types import SimpleNamespace
from libqtile.config import Key
from . import config as CFG


_WEBAPPS_JSON_PATH = "/home/jtekk/NixSetups/data/webapps.json"

with open(_WEBAPPS_JSON_PATH, 'r') as f:
    _webapps = json.load(f, object_hook=lambda d: SimpleNamespace(**d))

wa = _webapps
webapp_binds = [
    # Webapp shortcuts (mirrors mango/bindings/apps.nix)
    Key(CFG.mod_shift, "a", CFG.webapp(wa.audible.url), desc="Audible Audio Books"),
    Key(CFG.mod_shift, "c", CFG.webapp(wa.claude.url), desc="Claude AI"),
    Key(CFG.mod_shift, "g", CFG.webapp(wa.gemini.url), desc="Gemini AI"),
    Key(CFG.mod_shift, "h", CFG.webapp(wa.hbomax.url), desc="HBO Max"),
    Key(CFG.mod_shift, "i", CFG.webapp(wa.instagram.url), desc="Instagram"),
    Key(CFG.mod_shift, "m", CFG.webapp(wa.zohomail.url), desc="Zoho Mail"),
    Key(CFG.mod_shift, "n", CFG.webapp(wa.netflix.url), desc="Netflix"),
    Key(CFG.mod_shift, "o", CFG.webapp(wa.chatgpt.url), desc="ChatGPT"),
    Key(CFG.mod_shift, "t", CFG.webapp(wa.teams.url), desc="Microsoft Teams"),
    Key(CFG.mod_shift, "u", CFG.webapp(wa.upwork.url), desc="Upwork"),
    Key(CFG.mod_shift, "y", CFG.webapp(wa.youtube.url), desc="YouTube"),
]
