# Helper functions for AppImage management
{ lib, pkgs }:

let
  inherit (lib) optionalString;
  inherit (pkgs) appimageTools fetchurl writeShellScriptBin makeDesktopItem;
in rec {
  # Helper to wrap an AppImage with proper Nix integration
  mkAppImage = {
    pname,
    version,
    src,
    description ? "",
    homepage ? "",
    license ? lib.licenses.unfree,
    platforms ? [ "x86_64-linux" ],
    extraPkgs ? pkgs: [],
    extraInstallCommands ? "",
    extraEnv ? {},
    desktopName ? null,
    icon ? null,
    categories ? [ "Application" ],
    mimeTypes ? [],
    startupNotify ? true,
    terminal ? false
  }: let
    # Create the wrapped AppImage
    wrappedAppImage = appimageTools.wrapType2 {
      inherit pname version src extraPkgs;

      extraInstallCommands = ''
        # Install desktop file if parameters are provided
        ${optionalString (desktopName != null) ''
          mkdir -p $out/share/applications
          cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
        ''}

        # Extract and install icon if possible
        ${optionalString (icon != null) ''
          mkdir -p $out/share/icons/hicolor/512x512/apps
          # Try to extract icon from AppImage
          ${pkgs.libarchive}/bin/bsdtar -xOf $src '*.png' > icon.png 2>/dev/null || true
          if [ -f icon.png ] && [ -s icon.png ]; then
            mv icon.png $out/share/icons/hicolor/512x512/apps/${pname}.png
          fi
        ''}

        # Wrap the binary with environment variables if provided
        ${optionalString (extraEnv != {}) ''
          # Create a wrapper script with environment variables
          mv $out/bin/${pname} $out/bin/.${pname}-unwrapped
          cat > $out/bin/${pname} << EOF
#!/bin/sh
# Unset DISPLAY to force Wayland for Electron apps when GDK_BACKEND is set to wayland
if [ "\$GDK_BACKEND" = "wayland" ]; then
  unset DISPLAY
fi
${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "export ${k}=\"${v}\"") extraEnv)}
exec $out/bin/.${pname}-unwrapped "\$@"
EOF
          chmod +x $out/bin/${pname}
        ''}

        # Any additional install commands
        ${extraInstallCommands}
      '';
    };

    # Create desktop entry if desktop name is provided
    desktopItem = if desktopName != null then makeDesktopItem {
      name = pname;
      exec = pname;
      inherit desktopName categories mimeTypes startupNotify terminal;
      comment = description;
      icon = if icon != null then icon else pname;
    } else null;

  in wrappedAppImage // {
    meta = {
      inherit description homepage license platforms;
      mainProgram = pname;
    };
  };

  # Helper for fetching AppImages from GitHub releases
  fetchGithubAppImage = {
    owner,
    repo,
    version,
    fileName,
    sha256
  }: fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/${version}/${fileName}";
    inherit sha256;
  };

  # Helper for fetching the latest GitHub release
  fetchLatestGithubAppImage = {
    owner,
    repo,
    fileName,
    sha256
  }: fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/latest/download/${fileName}";
    inherit sha256;
  };

  # Create a simple wrapper script for an AppImage stored outside Nix store
  mkAppImageWrapper = {
    name,
    appImagePath,
    extraEnv ? {}
  }: writeShellScriptBin name ''
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "export ${k}=${v}") extraEnv)}
    exec ${pkgs.appimage-run}/bin/appimage-run "${appImagePath}" "$@"
  '';

  # Check if system needs AppImage support enabled
  needsAppImageSupport = config:
    (config.programs.appimages.packages != {}) ||
    (config.programs.appimages.enable or false);
}