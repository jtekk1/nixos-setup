{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "webapp-custom-icons";
  src = ./.;

  installPhase = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mkdir -p $out/share/icons/hicolor/scalable/apps

    # Install PNG icons
    cp ${./hbomax.png} $out/share/icons/hicolor/256x256/apps/hbomax.png
    cp ${./claude.png} $out/share/icons/hicolor/256x256/apps/claude.png
    cp ${./chatgpt.png} $out/share/icons/hicolor/256x256/apps/chatgpt.png
    cp ${./gemini.png} $out/share/icons/hicolor/256x256/apps/gemini.png
    cp ${./zohomail.png} $out/share/icons/hicolor/256x256/apps/zohomail.png

    # Install SVG icon
    cp ${./nerdfonts.svg} $out/share/icons/hicolor/scalable/apps/nerdfonts-cheatsheet.svg
  '';

  meta = {
    description = "Custom icons for web applications";
  };
}
