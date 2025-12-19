# Qtile Screens and Bar Configuration
# Using qtile-extras for enhanced widgets
# See: https://qtile-extras.readthedocs.io/

from libqtile import bar, widget
from libqtile.config import Screen

# Try to import qtile-extras widgets, fall back to standard if unavailable
try:
    from qtile_extras import widget as extrawidget
    from qtile_extras.widget.decorations import RectDecoration
    HAS_EXTRAS = True
except ImportError:
    HAS_EXTRAS = False

from colors import colors

# Widget defaults
widget_defaults = dict(
    font="CaskaydiaMono Nerd Font",
    fontsize=14,
    padding=8,
    foreground=colors["fg_primary"],
    background=colors["bg_primary"],
)
extension_defaults = widget_defaults.copy()

# Bar configuration
def create_bar():
    widgets = [
        widget.Spacer(length=8),

        widget.GroupBox(
            active=colors["fg_primary"],
            inactive=colors["fg_dim"],
            highlight_method="line",
            highlight_color=[colors["bg_secondary"], colors["bg_secondary"]],
            this_current_screen_border=colors["accent_primary"],
            this_screen_border=colors["accent_secondary"],
            other_current_screen_border=colors["accent_tertiary"],
            other_screen_border=colors["border_inactive"],
            urgent_border=colors["color1"],
            rounded=False,
            disable_drag=True,
        ),

        widget.Spacer(length=16),

        widget.CurrentLayout(
            foreground=colors["accent_primary"],
        ),

        widget.Spacer(),

        widget.Clock(
            format="%a %b %d  %H:%M",
            foreground=colors["fg_primary"],
        ),

        widget.Spacer(),

        widget.CPU(
            format=" {load_percent}%",
            foreground=colors["color4"],
        ),

        widget.Memory(
            format=" {MemUsed:.0f}{mm}",
            foreground=colors["color5"],
        ),

        widget.Spacer(length=16),

        widget.PulseVolume(
            fmt=" {}",
            foreground=colors["color6"],
        ),

        widget.Spacer(length=16),

        widget.Systray(),

        widget.Spacer(length=8),
    ]

    return bar.Bar(
        widgets,
        size=32,
        background=colors["bg_primary"],
        margin=[8, 8, 0, 8],  # top, right, bottom, left
        opacity=0.95,
    )

# Screen configuration
screens = [
    Screen(
        top=create_bar(),
        wallpaper_mode="fill",
    ),
]
