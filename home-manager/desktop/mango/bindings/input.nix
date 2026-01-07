{ pkgs, osConfig ? null, ... }:

let
  # Host detection for conditional settings
  hostname = if osConfig != null then
    osConfig.networking.hostName
  else
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile /etc/hostname);
  isThinkpad = hostname == "thinkpad";
in
{
  wayland.windowManager.mango.settings = ''
    ${if isThinkpad then ''
    # Gesture bindings (3-finger: focus, 4-finger: workspaces/overview)
    gesturebind=none,left,3,focusdir,left
    gesturebind=none,right,3,focusdir,right
    gesturebind=none,up,3,focusdir,up
    gesturebind=none,down,3,focusdir,down
    gesturebind=none,left,4,viewtoleft_have_client,0
    gesturebind=none,right,4,viewtoright_have_client,0
    gesturebind=none,up,4,toggleoverview
    gesturebind=none,down,4,toggleoverview
    '' else ""}
  '';
}
