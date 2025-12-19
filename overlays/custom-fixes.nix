# This overlay is a function that takes your flake's `inputs` as an argument
inputs: final: prev:

let
  # This now uses the `inputs` argument we passed in
  pkgs-stable = import inputs.nixpkgs-stable {
    localSystem = prev.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  # Override qtile-extras to skip flaky X11 positioning tests
  python3Packages = prev.python3Packages.overrideScope (pyFinal: pyPrev: {
    qtile-extras = pyPrev.qtile-extras.overrideAttrs (old: {
      doCheck = false;
    });
  });

  python3 = prev.python3.override {
    packageOverrides = pyFinal: pyPrev: {
      qtile-extras = pyPrev.qtile-extras.overrideAttrs (old: {
        doCheck = false;
      });
    };
  };

  # Use the working pamixer from the stable channel
  pamixer = pkgs-stable.pamixer;

  # Fix clblast CMake version issue
  clblast = prev.clblast.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace CMakeLists.txt \
        --replace "cmake_minimum_required(VERSION 2.8.11)" "cmake_minimum_required(VERSION 3.5)" \
        --replace "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.5)" \
        --replace "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.5)"
    '';
  });

  # Fix qgnomeplatform CMake version
  qgnomeplatform = prev.qgnomeplatform.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags
      ++ [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];
  });

  # Opencode is temporarily disabled in dev.nix due to npm deps issues
  # Keep this here in case we need to re-enable later
  # opencode = prev.opencode.overrideAttrs (oldAttrs: {
  #   npmDepsHash = "sha256-...";
  # });

  # Bluefin wallpapers - dinosaur images from Universal Blue's Bluefin project
  bluefin-wallpapers = prev.callPackage ../software/bluefin-wallpapers.nix { };

  # OpenRGB git version - for newer hardware support (B850 chipset, DDR5 RGB)
  openrgb-git = prev.openrgb.overrideAttrs (oldAttrs: rec {
    version = "git-unstable-2025-01-27";

    src = prev.fetchFromGitHub {
      owner = "CalcProgrammer1";
      repo = "OpenRGB";
      rev = "master";
      sha256 = "sha256-brEt1DLAEn9qfFpw9SR40TocKPG6ku5u57wwEZpyHHo=";
    };

    # Remove patches that don't apply to git version
    patches = [ ];

    # Override postPatch to fix the chmod substitution issue
    postPatch = ''
      patchShebangs scripts/build-udev-rules.sh
    '';

    # Fix the udev rules to not use /usr/bin/env
    postInstall = (oldAttrs.postInstall or "") + ''
      if [ -f $out/lib/udev/rules.d/60-openrgb.rules ]; then
        sed -i 's|/usr/bin/env|${prev.coreutils}/bin/env|g' $out/lib/udev/rules.d/60-openrgb.rules
      fi
    '';
  });

  # OpenRGB with plugins - git version
  openrgb-with-all-plugins-git = prev.openrgb-with-all-plugins.overrideAttrs
    (oldAttrs: rec {
      version = "git-unstable-2025-01-27";

      src = prev.fetchFromGitHub {
        owner = "CalcProgrammer1";
        repo = "OpenRGB";
        rev = "master";
        sha256 = "sha256-brEt1DLAEn9qfFpw9SR40TocKPG6ku5u57wwEZpyHHo=";
      };

      # Remove patches that don't apply to git version
      patches = [ ];

      # Override postPatch to fix the chmod substitution issue
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
      '';

      # Fix the udev rules to not use /usr/bin/env
      postInstall = (oldAttrs.postInstall or "") + ''
        if [ -f $out/lib/udev/rules.d/60-openrgb.rules ]; then
          sed -i 's|/usr/bin/env|${prev.coreutils}/bin/env|g' $out/lib/udev/rules.d/60-openrgb.rules
        fi
      '';
    });
}
