{ pkgs, ... }:

{
  wayland.windowManager.mango.settings = ''
    # Monitor rules (set default layouts)
    # name,mfact,nmaster,layout,transform,scale,x,y,width,height,refreshrate

    # NOTE: When using scaling on monitors, adjacent monitors MUST be positioned
    # at the LOGICAL pixel boundary, not physical boundary.
    # Formula: logical_width = physical_width / scale_factor
    # Example: DP-1 is 5120px wide with 1.3 scale = 3938 logical pixels

    # Main monitor
    monitorrule=DP-1,0.55,1,center_tile,0,1,0,0,5120,2160,60

    # Projector: Single window fullscreen focus (positioned at logical boundary: 5120/1.3 ≈ 3938)
    monitorrule=HDMI-A-2,0.55,1,tile,0,1,5120,0,1920,1080,60
  '';
}
