# Color conversion utilities for theme system
{ lib }:

rec {
  # Convert hex color to rgba format
  # Example: hexToRgba "#2596be" 1.0 -> "rgba(37,150,190,1.0)"
  hexToRgba = hex: alpha: let
    hexToInt = s:
      let
        chars = lib.stringToCharacters s;
        hexDigit = c:
          if c == "0" then 0
          else if c == "1" then 1
          else if c == "2" then 2
          else if c == "3" then 3
          else if c == "4" then 4
          else if c == "5" then 5
          else if c == "6" then 6
          else if c == "7" then 7
          else if c == "8" then 8
          else if c == "9" then 9
          else if c == "a" || c == "A" then 10
          else if c == "b" || c == "B" then 11
          else if c == "c" || c == "C" then 12
          else if c == "d" || c == "D" then 13
          else if c == "e" || c == "E" then 14
          else if c == "f" || c == "F" then 15
          else 0;
      in
        if builtins.length chars == 1 then hexDigit (builtins.head chars)
        else (hexDigit (builtins.head chars)) * 16 + hexDigit (builtins.elemAt chars 1);
    r = hexToInt (builtins.substring 1 2 hex);
    g = hexToInt (builtins.substring 3 2 hex);
    b = hexToInt (builtins.substring 5 2 hex);
  in "rgba(${toString r},${toString g},${toString b},${toString alpha})";

  # Convert hex color to 0xRRGGBBaa format (for Mango WM)
  # Example: hexTo0xFormat "#2596be" "ff" -> "0x2596beff"
  hexTo0xFormat = hex: alpha:
    "0x${builtins.substring 1 6 hex}${alpha}";

  # Strip # from hex color
  stripHash = hex: builtins.substring 1 6 hex;

  # Add # to hex color if missing
  ensureHash = hex:
    if builtins.substring 0 1 hex == "#" then hex else "#${hex}";
}