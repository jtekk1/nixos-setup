{ pkgs, config, ... }:

let
  colors = config.theme.colors;
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
    blur_layer=1
    blur_optimized=1
    blur_params_num_passes=3
    blur_params_radius=5
    blur_params_noise=0.02
    blur_params_brightness=0.9
    blur_params_contrast=0.9
    blur_params_saturation=1.2

    shadows=1
    layer_shadows=1
    shadow_only_floating=0
    shadows_size=12
    shadows_blur=15
    shadows_position_x=0
    shadows_position_y=0
    shadowscolor=0x000000ff

    border_radius=4
    no_radius_when_single=0
    focused_opacity=1.0
    unfocused_opacity=0.70

    # Animation Configuration
    animations=1
    layer_animations=1
    animation_type_open=zoom
    animation_type_close=zoom
    layer_animation_type_open=zoom
    layer_animation_type_close=zoom
    animation_fade_in=1
    animation_fade_out=1
    tag_animation_direction=230
    zoom_initial_ratio=0.3
    zoom_end_ratio=0.7
    fadein_begin_opacity=0.1
    fadeout_begin_opacity=0.8
    animation_duration_move=130
    animation_duration_open=130
    animation_duration_tag=100
    animation_duration_close=100
    animation_curve_open=1.0,-0.55,0.04,1.1
    animation_curve_move=1.0,-0.55,0.04,1.1
    animation_curve_tag=1.0,-0.55,0.04,1.1
    animation_curve_close=1.0,-0.55,0.04,1.1

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

    # Overview Setting
    hotarea_size=10
    enable_hotarea=0
    ov_tab_mode=1
    overviewgappi=5
    overviewgappo=30

    # Misc
    xwayland_persistence=1
    syncobj_enable=1
    no_border_when_single=0
    axis_bind_apply_timeout=100
    focus_on_activate=1
    inhibit_regardless_of_visibility=0
    sloppyfocus=1
    warpcursor=1
    focus_cross_monitor=0
    focus_cross_tag=0
    enable_floating_snap=1
    snap_distance=50
    cursor_size=24
    cursor_theme=Yaru
    cursor_hide_timeout=0
    drag_tile_to_tile=1
    single_scratchpad=1
    view_current_to_back=0

    # Keyboard
    repeat_rate=50
    repeat_delay=300
    numlockon=1
    xkb_rules_layout=us

    # Trackpad
    disable_trackpad=1
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    mouse_natural_scrolling=0
    trackpad_natural_scrolling=0
    disable_while_typing=1
    left_handed=0
    middle_button_emulation=0
    swipe_min_threshold=1
    accel_profile=2
    accel_speed=0.0

    # Appearance (gaps and borders)
    gappih=20
    gappiv=20
    gappoh=20
    gappov=20
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
