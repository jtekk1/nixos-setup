# Glow markdown viewer configuration with theme support
{ config, pkgs, lib, ... }:

let
  colors = config.theme.colors;
  themeName = config.theme.name;

  # Generate glamour style JSON for glow
  glamourStyle = builtins.toJSON {
    document = {
      block_prefix = "\n";
      block_suffix = "\n";
      color = colors.fg_primary;
      margin = 2;
    };
    block_quote = {
      indent = 1;
      indent_token = "│ ";
      color = colors.fg_dim;
      italic = true;
    };
    paragraph = {};
    list = {
      level_indent = 2;
    };
    heading = {
      block_suffix = "\n";
      color = colors.accent_primary;
      bold = true;
    };
    h1 = {
      prefix = "# ";
      color = colors.accent_primary;
      bold = true;
    };
    h2 = {
      prefix = "## ";
      color = colors.accent_secondary;
      bold = true;
    };
    h3 = {
      prefix = "### ";
      color = colors.accent_tertiary;
      bold = true;
    };
    h4 = {
      prefix = "#### ";
      color = colors.color5;
      bold = true;
    };
    h5 = {
      prefix = "##### ";
      color = colors.color6;
      bold = true;
    };
    h6 = {
      prefix = "###### ";
      color = colors.fg_secondary;
      bold = true;
    };
    text = {};
    strikethrough = {
      crossed_out = true;
    };
    emph = {
      italic = true;
    };
    strong = {
      bold = true;
    };
    hr = {
      color = colors.fg_dim;
      format = "\n--------\n";
    };
    item = {
      block_prefix = "• ";
    };
    enumeration = {
      block_prefix = ". ";
    };
    task = {
      ticked = "[✓] ";
      unticked = "[ ] ";
    };
    link = {
      color = colors.url;
      underline = true;
    };
    link_text = {
      color = colors.accent_secondary;
      bold = true;
    };
    image = {
      color = colors.url;
      underline = true;
    };
    image_text = {
      color = colors.accent_tertiary;
      format = "Image: {{.text}}";
    };
    code = {
      color = colors.color2;
      background_color = colors.bg_secondary;
    };
    code_block = {
      color = colors.fg_primary;
      margin = 2;
      chroma = {
        text = { color = colors.fg_primary; };
        error = { color = colors.color1; };
        comment = { color = colors.fg_dim; italic = true; };
        comment_preproc = { color = colors.fg_dim; };
        keyword = { color = colors.accent_primary; bold = true; };
        keyword_reserved = { color = colors.accent_primary; bold = true; };
        keyword_namespace = { color = colors.accent_primary; };
        keyword_type = { color = colors.accent_secondary; };
        operator = { color = colors.fg_secondary; };
        punctuation = { color = colors.fg_primary; };
        name = { color = colors.fg_primary; };
        name_builtin = { color = colors.accent_secondary; };
        name_tag = { color = colors.accent_primary; };
        name_attribute = { color = colors.accent_tertiary; };
        name_class = { color = colors.accent_tertiary; bold = true; };
        name_constant = { color = colors.color3; };
        name_decorator = { color = colors.color5; };
        name_exception = { color = colors.color1; };
        name_function = { color = colors.accent_primary; };
        name_other = { color = colors.fg_primary; };
        literal = { color = colors.color2; };
        literal_number = { color = colors.accent_tertiary; };
        literal_date = { color = colors.accent_tertiary; };
        literal_string = { color = colors.color2; };
        literal_string_escape = { color = colors.accent_secondary; };
        generic_deleted = { color = colors.color1; };
        generic_emph = { italic = true; };
        generic_inserted = { color = colors.color2; };
        generic_strong = { bold = true; };
        generic_subheading = { color = colors.accent_secondary; };
        background = { background_color = colors.bg_primary; };
      };
    };
    table = {
      center_separator = "┼";
      column_separator = "│";
      row_separator = "─";
    };
    definition_list = {};
    definition_term = {};
    definition_description = {
      block_prefix = "\n🠶 ";
    };
    html_block = {};
    html_span = {};
  };
in
{
  home.packages = [ pkgs.glow ];

  # Glow config file
  home.file.".config/glow/glow.yml".text = ''
    # Glow configuration
    style: "${config.home.homeDirectory}/.config/glow/${themeName}.json"
    local: false
    mouse: true
    pager: true
    width: 120
  '';

  # Custom glamour style based on theme
  home.file.".config/glow/${themeName}.json".text = glamourStyle;
}
