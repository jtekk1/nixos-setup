{ pkgs, ... }:

let
  bluefin-wallpapers = pkgs.stdenv.mkDerivation rec {
    pname = "bluefin-wallpapers";
    version = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "ublue-os";
      repo = "packages";
      rev = "c3a2e05e0a4638880ed607a12842cc95d26ff7e3";
      hash = "sha256-0h6a1s9mvk72iws44137afpynzfglcv17kyb1a5fa279rvylxa0m";
    };

    nativeBuildInputs = [ pkgs.libjxl ];

    installPhase = ''
      mkdir -p $out/share/backgrounds/bluefin
      mkdir -p $out/share/gnome-background-properties

      # Copy all wallpaper files (JXL format)
      if [ -d packages/bluefin/wallpapers/images ]; then
        cp packages/bluefin/wallpapers/images/*.jxl $out/share/backgrounds/bluefin/ 2>/dev/null || true
        cp packages/bluefin/wallpapers/images/*.xml $out/share/backgrounds/bluefin/ 2>/dev/null || true

        # Convert JXL to PNG for better compatibility
        cd packages/bluefin/wallpapers/images
        for jxl in *.jxl; do
          if [ -f "$jxl" ]; then
            png="''${jxl%.jxl}.png"
            ${pkgs.libjxl}/bin/djxl "$jxl" "$out/share/backgrounds/bluefin/$png" 2>/dev/null || echo "Skipping $jxl"
          fi
        done
      fi

      # Copy GNOME background properties if they exist
      if [ -d packages/bluefin/wallpapers/gnome-background-properties ]; then
        cp packages/bluefin/wallpapers/gnome-background-properties/*.xml $out/share/gnome-background-properties/ 2>/dev/null || true
      fi
    '';

    meta = with pkgs.lib; {
      description = "Beautiful dinosaur wallpapers from Universal Blue's Bluefin project";
      homepage = "https://github.com/ublue-os/packages";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ bluefin-wallpapers ];
}
