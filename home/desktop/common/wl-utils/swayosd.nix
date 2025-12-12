{ pkgs, config, ... }:

{
  # SwayOSD configuration
  xdg.configFile = {
    "swayosd/config.toml".text = ''
      [server]
      show_percentage = true
      max_volume = 100
      style = "./style.css"

      # Display settings
      top_margin = 0.85
      display = "overlay"  # Show on the overlay layer

      # Timeout settings
      timeout = 2000  # Hide after 2 seconds

      # Audio settings
      volume_step = 5

      # Brightness settings
      brightness_step = 5

      # Capslock/Numlock indicators
      show_capslock = true
      show_numlock = true

      # Size and positioning
      width = 400
      height = 100
    '';

    "swayosd/style.css".text = ''
      /* Define theme colors for SwayOSD */
      @define-color background-color rgba(32, 0, 40, 0.95);
      @define-color border-color #00FFFF;
      @define-color label #00FFFF;
      @define-color image #00FFFF;
      @define-color progress #DD00FF;
      @define-color progress-bg rgba(0, 255, 255, 0.2);
      @define-color caps-active #FF0040;
      @define-color num-active #00FF40;

      window {
        border-radius: 8px;
        opacity: 1.0;
        border: 3px solid @border-color;
        background-color: @background-color;
        padding: 10px;
        box-shadow: 0 0 20px rgba(0, 255, 255, 0.3);
      }

      label {
        font-family: 'CaskaydiaMono Nerd Font';
        font-size: 14pt;
        font-weight: bold;
        color: @label;
        text-shadow: 0 0 5px rgba(0, 255, 255, 0.5);
      }

      image {
        color: @image;
        margin: 10px;
      }

      progressbar {
        border-radius: 4px;
        min-height: 8px;
        background-color: @progress-bg;
      }

      progress {
        background-color: @progress;
        border-radius: 4px;
        min-height: 8px;
      }

      /* Capslock indicator */
      .caps-lock-active {
        color: @caps-active;
      }

      /* Numlock indicator */
      .num-lock-active {
        color: @num-active;
      }

      /* Animation */
      @keyframes slide-in {
        from {
          opacity: 0;
          transform: translateY(-20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      window {
        animation: slide-in 0.2s ease-out;
      }
    '';
  };
}