{ lib, ... }:

{
  options.jtekk.desktop-env = lib.mkOption {
    type = lib.types.str;
    default = "none";
    description = "Active desktop environment (server, mango-hypr)";
  };
}
