{ pkgs, osConfig ? null, ... }:

let
  hostname = if osConfig != null then osConfig.networking.hostName else "unknown";

  # Host-specific monitor configurations
  monitorRules = {
    deepspace = ''
      # Monitor rules (set default layouts)
      # name,mfact,nmaster,layout,transform,scale,x,y,width,height,refreshrate

      # Main ultrawide monitor - 40% master
      monitorrule=DP-1,0.40,1,center_tile,0,1,0,0,5120,2160,60

      # Projector (disabled by default, enabled via keybind)
      monitorrule=HDMI-A-2,0.40,1,tile,0,1,5120,0,1920,1080,60
    '';

    thinkpad = ''
      # Monitor rules (set default layouts)
      # name,mfact,nmaster,layout,transform,scale,x,y,width,height,refreshrate

      # Laptop internal display - 55% master
      monitorrule=eDP-1,0.55,1,center_tile,0,1,0,0,1920,1080,60

      # External ultrawide (docked) - 40% master
      monitorrule=HDMI-A-2,0.40,1,center_tile,0,1,0,0,2560,1080,60
    '';
  };

  # Fallback for unknown hosts
  defaultRules = ''
    # Default monitor rule
    monitorrule=*,0.50,1,tile,0,1,0,0,1920,1080,60
  '';
in {
  wayland.windowManager.mango.settings = monitorRules.${hostname} or defaultRules;
}
