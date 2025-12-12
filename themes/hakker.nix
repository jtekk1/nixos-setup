# Hakker Green Theme Color Definitions
# A vibrant green hacker-inspired theme for maximum visibility

{
  # Core color palette - Dark backgrounds with green accents
  bg_primary = "#000000";      # Pure black background
  bg_secondary = "#0a0a0a";    # Very dark gray for panels
  bg_tertiary = "#1a1a1a";     # Dark gray for UI elements

  # Text colors - Green spectrum
  fg_primary = "#ccffee";      # Light green-white for primary text
  fg_secondary = "#00ff99";    # Bright green for secondary text
  fg_dim = "#333333";          # Dark gray for dimmed text

  # Accent colors - Various greens
  accent_primary = "#00ff99";   # Bright green - primary accent
  accent_secondary = "#00cc77"; # Medium green - borders/accents
  accent_tertiary = "#66ff66";  # Lime green - highlights

  # Special purpose colors
  cursor = "#ccffee";          # Light green cursor
  selection_bg = "#00cc77";    # Medium green selection
  selection_fg = "#000000";    # Black text on selection
  url = "#00ffcc";            # Cyan-green for URLs

  # Border colors for Hyprland/Mango
  border_active_1 = "#00ff99";  # Bright green gradient start
  border_active_2 = "#00cc77";  # Medium green gradient end
  border_inactive = "#1a1a1a66"; # Dark gray with transparency

  # Terminal color palette (16 colors)
  color0 = "#000000";   # Black
  color1 = "#cccc66";   # Yellow-green (for errors)
  color2 = "#00ff99";   # Bright green
  color3 = "#dddd88";   # Light yellow
  color4 = "#00cc77";   # Medium green (blue replacement)
  color5 = "#66ff66";   # Lime green (magenta replacement)
  color6 = "#00ffcc";   # Cyan-green
  color7 = "#aaffcc";   # Light green-white

  # Bright variants
  color8 = "#333333";   # Bright black (dark gray)
  color9 = "#eeeeaa";   # Bright yellow (bright red replacement)
  color10 = "#00ff99";  # Bright green
  color11 = "#ffffdd";  # Bright yellow
  color12 = "#33ff99";  # Bright medium green
  color13 = "#99ff99";  # Bright lime green
  color14 = "#00ffcc";  # Bright cyan-green
  color15 = "#ccffee";  # Bright white (light green-white)

  # Mango-specific override colors
  mango_overrides = {
    rootcolor = "#000000";
    bordercolor = "#00ff99";
    focuscolor = "#00cc77";
    maxmizescreencolor = "#00ff99";
    urgentcolor = "#cccc66";
  };

  # Wallpapers specific to this theme
  wallpapers = [
    "hg-01.jpeg"
    "hg-02.jpeg"
    "hg-03.jpeg"
    "hg-04.jpeg"
    "hg-05.jpeg"
    "hg-06.png"
    "hg-07.png"
    "hg-08.png"
    "hg-09.png"
    "hg-10.jpeg"
    "hg-11.jpg"
  ];
}