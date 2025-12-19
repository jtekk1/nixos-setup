# Qtile Layouts
# See: https://docs.qtile.org/en/stable/manual/ref/layouts.html

from libqtile import layout
from libqtile.config import Match
from colors import colors

# Layout theme settings
layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": colors["border_active"],
    "border_normal": colors["border_inactive"],
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    # layout.Stack(num_stacks=2, **layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.TreeTab(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
]

floating_layout = layout.Floating(
    border_focus=colors["border_active"],
    border_normal=colors["border_inactive"],
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        # Add your floating rules here
    ]
)
