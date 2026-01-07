{ pkgs, config, osConfig ? null, ... }:

let
  colors = config.theme.colors;

  # Host detection for conditional settings
  hostname = if osConfig != null then
    osConfig.networking.hostName
  else
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile /etc/hostname);
  isThinkpad = hostname == "thinkpad";
  isDeepspace = hostname == "deepspace";
  # Use mango format (0xRRGGBBaa) for colors
  useOverrides = config.theme.name == "neuro-fusion" && colors.mangoOverrides
    != null;

  # Define colors based on theme
  rootColor = if useOverrides then
    colors.mangoOverrides.rootcolor + "ff"
  else
    colors.mango.bg_primary "ff";
  borderColor = if useOverrides then
    colors.mangoOverrides.bordercolor + "66"
  else
    colors.mango.accent_primary "66";
  focusColor = if useOverrides then
    colors.mangoOverrides.focuscolor + "ff"
  else
    colors.mango.accent_primary "ff";
  maxmizeScreenColor = if useOverrides then
    colors.mangoOverrides.maxmizescreencolor + "ff"
  else
    colors.mango.accent_primary "ff";
  urgentColor = if useOverrides then
    colors.mangoOverrides.urgentcolor + "ff"
  else
    colors.mango.accent_primary "ff";
in {
  wayland.windowManager.mango.settings = ''
    # Mango WM Configuration

    # Effects (blur disabled by default in mango-config, but we enable it)
    blur=1
    blur_layer=0
    blur_optimized=1
    blur_params_num_passes=3
    blur_params_radius=5
    blur_params_noise=0.09
    blur_params_brightness=0.9
    blur_params_contrast=0.9
    blur_params_saturation=1.2

    shadows=1
    layer_shadows=1
    shadow_only_floating=0
    shadows_size=8
    shadows_blur=15
    shadows_position_x=0
    shadows_position_y=0
    shadowscolor=0xbd93f9ff

    border_radius=4
    no_radius_when_single=0
    focused_opacity=1.0
    unfocused_opacity=0.70

    # Animation Configuration
    animations=1
    layer_animations=0
    animation_type_open=slide
    animation_type_close=zoom
    layer_animation_type_open=slide
    layer_animation_type_close=zoom
    animation_fade_in=1
    animation_fade_out=1
    tag_animation_direction=1
    zoom_initial_ratio=0.1
    zoom_end_ratio=0.1
    fadein_begin_opacity=0.1
    fadeout_begin_opacity=1.0
    animation_duration_move=500
    animation_duration_open=400
    animation_duration_tag=250
    animation_duration_close=400
    animation_duration_focus=150
    animation_curve_open=1.0,0,0.04,1.1
    animation_curve_move=1.0,0,0.04,1.1
    animation_curve_tag=1.0,0,0.04,1.1
    animation_curve_close=1.0,0,0.04,1.1
    animation_curve_focus=1.0,0.0,0.04,1.0
    animation_curve_opafadein=1.0,0.0,0.04,1.0
    animation_curve_opafadeout=1.0,0.0,0.04,1.0

    # Scroller Layout Setting
    scroller_structs=10
    scroller_default_proportion=0.33
    scroller_focus_center=0
    scroller_prefer_center=1
    edge_scroller_pointer_focus=1
    scroller_default_proportion_single=0.75
    scroller_proportion_preset=0.33,0.66,1.0

    # Master-Stack Layout Setting
    new_is_master=0
    smartgaps=1
    default_mfact=0.45
    default_smfact=0.45
    default_nmaster=1
    center_master_overspread=0
    center_when_single_stack=0

    # Overview Setting
    hotarea_size=10
    enable_hotarea=0
    ov_tab_mode=1
    overviewgappi=15
    overviewgappo=30

    # Misc
    xwayland_persistence=1
    syncobj_enable=1
    adaptive_sync=1
    allow_shortcuts_inhibit=1
    allow_tearing=1
    allow_lock_transparent=0
    no_border_when_single=0
    axis_bind_apply_timeout=100
    focus_on_activate=1
    inhibit_regardless_of_visibility=0
    sloppyfocus=1
    warpcursor=1
    focus_cross_monitor=0
    exchange_cross_monitor=0
    scratchpad_cross_monitor=0
    focus_cross_tag=0
    enable_floating_snap=1
    snap_distance=50
    cursor_size=24
    cursor_theme=oreo_spark_pink_cursors
    cursor_hide_timeout=0
    drag_tile_to_tile=1
    single_scratchpad=1
    view_current_to_back=0
    circle_layout=tile,center_tile,tgmix,scroller,grid

    # Keyboard
    repeat_rate=50
    repeat_delay=300
    numlockon=1
    xkb_rules_layout=us

    # Trackpad - only enable on thinkpad (laptop)
    disable_trackpad=${if isThinkpad then "0" else "1"}
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    mouse_natural_scrolling=0
    trackpad_natural_scrolling=0
    disable_while_typing=1
    left_handed=0
    middle_button_emulation=0
    swipe_min_threshold=20
    accel_profile=2
    accel_speed=0.0
    scroll_method=1
    click_method=1
    send_events_mode=0
    button_map=0

    # Appearance (gaps and borders)
    gappih=20
    gappiv=20
    gappoh=10
    gappov=10
    scratchpad_width_ratio=0.8
    scratchpad_height_ratio=0.9
    borderpx=3

    # Theme colors
    rootcolor=${rootColor}
    bordercolor=${borderColor}
    focuscolor=${focusColor}
    maximizescreencolor=${maxmizeScreenColor}
    urgentcolor=${urgentColor}
    scratchpadcolor=${focusColor}
    globalcolor=${focusColor}
    overlaycolor=${focusColor}
  '';
}
