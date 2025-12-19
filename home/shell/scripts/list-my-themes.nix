{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "list-my-themes" ''
# list-my-themes - Display all available NixOS themes with descriptions
# Usage: list-my-themes

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'
DIM='\033[2m'
ORANGE='\033[0;33m'
PINK='\033[1;35m'

# Theme-specific colors
PURPLE='\033[0;35m'
LIME='\033[1;32m'
BROWN='\033[0;33m'
TEAL='\033[0;36m'

echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo -e "                           ''${BOLD}''${WHITE}AVAILABLE NIXOS THEMES''${RESET}                              "
echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo

# Function to print theme info with colors
print_theme() {
    local name="$1"
    local trigger="$2"
    local description="$3"
    local example="$4"
    local theme_color="$5"

    echo -e "''${BLUE}┌─────────────────────────────────────────────────────────────────────────────''${RESET}"
    echo -e "''${BLUE}│''${RESET} ''${BOLD}Theme:''${RESET} ''${theme_color}''${name}''${RESET}"
    echo -e "''${BLUE}│''${RESET} ''${BOLD}Description:''${RESET} $description"
    echo -e "''${BLUE}│''${RESET} ''${BOLD}Trigger:''${RESET} ''${YELLOW}$trigger''${RESET}"
    echo -e "''${BLUE}│''${RESET} ''${BOLD}Usage:''${RESET} sudo nixos-rebuild switch --flake .#deepspace-{desktop}-''${YELLOW}$trigger''${RESET}"
    echo -e "''${BLUE}│''${RESET} ''${BOLD}Example:''${RESET} ''${GREEN}sudo nixos-rebuild switch --flake .#$example''${RESET}"
    echo -e "''${BLUE}└─────────────────────────────────────────────────────────────────────────────''${RESET}"
    echo
}

echo -e "''${BOLD}''${WHITE}── Original Themes ──''${RESET}"
echo

# List original themes
print_theme \
    "Neuro-Fusion" \
    "neurofusion" \
    "''${DIM}Purple/cyan/gold cyberpunk theme inspired by autism & ADHD neurology.''${RESET}" \
    "deepspace-mango-neurofusion" \
    "$MAGENTA"

print_theme \
    "Icy-Blue" \
    "icyblue" \
    "''${DIM}Cool blue tones with dark blue-black background and light blue accents.''${RESET}" \
    "deepspace-mango-icyblue" \
    "$CYAN"

print_theme \
    "Green-Hakker" \
    "hakker" \
    "''${DIM}Classic hacker aesthetic with bright green text on pure black background.''${RESET}" \
    "deepspace-mango-hakker" \
    "$LIME"

echo -e "''${BOLD}''${WHITE}── JTekk Arch Collection ──''${RESET}"
echo

# Popular themes
print_theme \
    "Catppuccin Macchiato" \
    "catppuccin" \
    "''${DIM}Soothing pastel theme with purple and pink accents.''${RESET}" \
    "deepspace-mango-catppuccin" \
    "$PINK"

print_theme \
    "Catppuccin Latte" \
    "latte" \
    "''${DIM}Light variant of Catppuccin with cream and pastel colors.''${RESET}" \
    "deepspace-mango-latte" \
    "$WHITE"

print_theme \
    "Gruvbox" \
    "gruvbox" \
    "''${DIM}Retro groove with warm browns, oranges and yellows.''${RESET}" \
    "deepspace-mango-gruvbox" \
    "$BROWN"

print_theme \
    "Tokyo Night" \
    "tokyonight" \
    "''${DIM}Tokyo city lights inspired dark theme with neon accents.''${RESET}" \
    "deepspace-mango-tokyonight" \
    "$BLUE"

print_theme \
    "Nord" \
    "nord" \
    "''${DIM}Arctic north-bluish clean and minimal color palette.''${RESET}" \
    "deepspace-mango-nord" \
    "$CYAN"

# Unique aesthetics
print_theme \
    "Everforest" \
    "everforest" \
    "''${DIM}Warm and comfortable forest green theme with earthy tones.''${RESET}" \
    "deepspace-mango-everforest" \
    "$GREEN"

print_theme \
    "Rose Pine" \
    "rosepine" \
    "''${DIM}Natural pine and rose color palette with muted tones.''${RESET}" \
    "deepspace-mango-rosepine" \
    "$PINK"

print_theme \
    "Kanagawa" \
    "kanagawa" \
    "''${DIM}Inspired by famous Japanese paintings with deep blues.''${RESET}" \
    "deepspace-mango-kanagawa" \
    "$BLUE"

# Specialized themes
print_theme \
    "Matte Black" \
    "matteblack" \
    "''${DIM}Pure dark theme with minimal color accents for focus.''${RESET}" \
    "deepspace-mango-matteblack" \
    "$WHITE"

print_theme \
    "Osaka Jade" \
    "jade" \
    "''${DIM}Japanese-inspired jade green theme with zen aesthetics.''${RESET}" \
    "deepspace-mango-jade" \
    "$TEAL"

print_theme \
    "Ristretto" \
    "ristretto" \
    "''${DIM}Coffee-inspired warm brown theme with cream accents.''${RESET}" \
    "deepspace-mango-ristretto" \
    "$BROWN"

print_theme \
    "Apprentice" \
    "apprentice" \
    "''${DIM}Low-contrast muted theme designed to be easy on the eyes.''${RESET}" \
    "deepspace-mango-apprentice" \
    "$BLUE"

echo -e "''${BOLD}''${WHITE}── Tomorrow Theme Collection ──''${RESET}"
echo

print_theme \
    "Tomorrow" \
    "tomorrow" \
    "''${DIM}Light theme with muted colors and sensible syntax highlighting.''${RESET}" \
    "deepspace-mango-tomorrow" \
    "$WHITE"

print_theme \
    "Tomorrow Night" \
    "tomorrow-night" \
    "''${DIM}Dark theme with muted, cool-toned colors for extended coding.''${RESET}" \
    "deepspace-mango-tomorrow-night" \
    "$BLUE"

print_theme \
    "Tomorrow Eighties" \
    "tomorrow-eighties" \
    "''${DIM}Retro 80s-inspired dark theme with muted pastel colors.''${RESET}" \
    "deepspace-mango-tomorrow-eighties" \
    "$PINK"

print_theme \
    "Tomorrow Bright" \
    "tomorrow-bright" \
    "''${DIM}High-contrast dark theme with vibrant accent colors on black.''${RESET}" \
    "deepspace-mango-tomorrow-bright" \
    "$CYAN"

echo -e "''${BOLD}''${WHITE}── Popular Community Themes ──''${RESET}"
echo

print_theme \
    "Synthwave Alpha" \
    "synthwave" \
    "''${DIM}Synthwave-inspired with vibrant purples, magentas, and cyans.''${RESET}" \
    "deepspace-mango-synthwave" \
    "$MAGENTA"

print_theme \
    "Srcery" \
    "srcery" \
    "''${DIM}Dark theme with carefully chosen vibrant colors.''${RESET}" \
    "deepspace-mango-srcery" \
    "$RED"

print_theme \
    "Sonokai" \
    "sonokai" \
    "''${DIM}High-contrast elegant dark theme with sophisticated colors.''${RESET}" \
    "deepspace-mango-sonokai" \
    "$PURPLE"

print_theme \
    "Solarized Dark" \
    "solarized-dark" \
    "''${DIM}Precision colors for machines and people - dark variant.''${RESET}" \
    "deepspace-mango-solarized-dark" \
    "$TEAL"

print_theme \
    "Solarized Light" \
    "solarized-light" \
    "''${DIM}Precision colors for machines and people - light variant.''${RESET}" \
    "deepspace-mango-solarized-light" \
    "$YELLOW"

print_theme \
    "Hyper Snazzy" \
    "snazzy" \
    "''${DIM}Elegant dark theme with bright, snazzy colors.''${RESET}" \
    "deepspace-mango-snazzy" \
    "$PINK"

print_theme \
    "Smyck" \
    "smyck" \
    "''${DIM}Pleasant color scheme designed for comfortable eye experience.''${RESET}" \
    "deepspace-mango-smyck" \
    "$BLUE"

print_theme \
    "Selenized Dark" \
    "selenized-dark" \
    "''${DIM}Scientifically designed palette with perceptually uniform colors.''${RESET}" \
    "deepspace-mango-selenized-dark" \
    "$TEAL"

print_theme \
    "Selenized Light" \
    "selenized-light" \
    "''${DIM}Scientifically designed light palette with balanced colors.''${RESET}" \
    "deepspace-mango-selenized-light" \
    "$YELLOW"

echo -e "''${BOLD}''${WHITE}── Classic & Iconic Themes ──''${RESET}"
echo

print_theme \
    "Ocean Dark" \
    "ocean-dark" \
    "''${DIM}Muted oceanic theme based on base16 Ocean palette.''${RESET}" \
    "deepspace-mango-ocean-dark" \
    "$TEAL"

print_theme \
    "Nightfox" \
    "nightfox" \
    "''${DIM}Highly customizable modern theme with elegant colors.''${RESET}" \
    "deepspace-mango-nightfox" \
    "$BLUE"

print_theme \
    "Monokai" \
    "monokai" \
    "''${DIM}The iconic 2006 theme by Wimer Hazenberg - Sublime Text classic.''${RESET}" \
    "deepspace-mango-monokai" \
    "$MAGENTA"

print_theme \
    "Kokuban" \
    "kokuban" \
    "''${DIM}Blackboard-style theme with dark green background (Japanese inspired).''${RESET}" \
    "deepspace-mango-kokuban" \
    "$GREEN"

print_theme \
    "Hemisu Dark" \
    "hemisu-dark" \
    "''${DIM}Balanced dark theme with carefully selected harmonious colors.''${RESET}" \
    "deepspace-mango-hemisu-dark" \
    "$BLUE"

print_theme \
    "Hemisu Light" \
    "hemisu-light" \
    "''${DIM}Balanced light theme with carefully selected harmonious colors.''${RESET}" \
    "deepspace-mango-hemisu-light" \
    "$WHITE"

print_theme \
    "Gotham" \
    "gotham" \
    "''${DIM}Very dark theme inspired by Batman's city with deep blues.''${RESET}" \
    "deepspace-mango-gotham" \
    "$CYAN"

print_theme \
    "Fairyfloss" \
    "fairyfloss" \
    "''${DIM}Fun purple-based theme with vibrant pinks and yellows.''${RESET}" \
    "deepspace-mango-fairyfloss" \
    "$PINK"

print_theme \
    "Everblush" \
    "everblush" \
    "''${DIM}Dark, vibrant and beautiful colorscheme with elegant design.''${RESET}" \
    "deepspace-mango-everblush" \
    "$BLUE"

print_theme \
    "Dracula" \
    "dracula" \
    "''${DIM}Popular dark theme with vibrant colors and WCAG accessibility.''${RESET}" \
    "deepspace-mango-dracula" \
    "$PURPLE"

echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo -e "                              ''${BOLD}''${WHITE}DESKTOP OPTIONS''${RESET}                                  "
echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo
echo -e "  ''${BOLD}Available desktops:''${RESET} ''${GREEN}mango''${RESET}"
echo -e "  Replace ''${YELLOW}{desktop}''${RESET} in the command with your preferred window manager"
echo
echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo -e "                              ''${BOLD}''${WHITE}THEME SUMMARY''${RESET}                                    "
echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo
echo -e "  ''${BOLD}Total Themes:''${RESET} ''${YELLOW}38''${RESET}"
echo -e "  ''${BOLD}Light Themes:''${RESET} Catppuccin Latte, Rose Pine, Tomorrow, Solarized Light, Selenized Light, Hemisu Light"
echo -e "  ''${BOLD}Dark Themes:''${RESET} All others"
echo -e "  ''${BOLD}Most Popular:''${RESET} Catppuccin, Gruvbox, Tokyo Night, Nord"
echo
echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo -e "                                   ''${BOLD}''${WHITE}NOTES''${RESET}                                       "
echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
echo
echo -e "  ''${BOLD}•''${RESET} Themes only change ''${YELLOW}colors''${RESET}, not layouts or behaviors"
echo -e "  ''${BOLD}•''${RESET} All themes support: ''${GREEN}kitty''${RESET}, ''${GREEN}starship''${RESET}, ''${GREEN}btop''${RESET}, ''${GREEN}swaylock''${RESET}, ''${GREEN}waybar''${RESET}, ''${GREEN}wofi''${RESET}"
echo -e "  ''${BOLD}•''${RESET} Each theme includes its own set of ''${YELLOW}wallpapers''${RESET}"
echo -e "  ''${BOLD}•''${RESET} Current directory: ''${BLUE}$(pwd)''${RESET}"
echo
echo -e "''${CYAN}═══════════════════════════════════════════════════════════════════════════════''${RESET}"
    '')
  ];
}
