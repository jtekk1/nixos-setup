{ ... }:

{
  imports = [ ../common/waybar ];

  # Enable powerline styling
  programs.waybar.powerline = {
    enable = true;

    separators = {
      style = "triangle";
      inverted = true;
    };

    tails = {
      style = "inverted-triangle";
      inverted = true;
    };

    segment = {
      padding = "4px 10px";
      margin = "2px 0";
      fontWeight = 600;
    };

    separator.size = 22;

    transitions = {
      enable = true;
      duration = "800ms";
      timing = "ease-in-out";
    };
  };
}
