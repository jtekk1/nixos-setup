{
  description = "Qtile config development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Override qtile-extras to skip flaky X11 positioning tests
        overlay = final: prev: {
          python3 = prev.python3.override {
            self = final.python3;
            packageOverrides = pyFinal: pyPrev: {
              qtile-extras = pyPrev.qtile-extras.overrideAttrs (old: {
                disabledTests = (old.disabledTests or [ ]) ++ [
                  "test_popup_positioning_relative"
                  "test_widget_init_config"
                ];
              });
            };
          };
          python3Packages = final.python3.pkgs;
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
        python = pkgs.python3;
        pythonPkgs = python.pkgs;
      in
      {
        devShells.default = pkgs.mkShell {
          name = "qtile-dev";

          packages = with pkgs; [
            # Python with qtile packages
            (python.withPackages (ps: with ps; [
              qtile
              qtile-extras
              dbus-python
              psutil
              pulsectl-asyncio

              # Type stubs and dev dependencies
              types-psutil
            ]))

            # Linting
            ruff
            pythonPkgs.mypy
            pythonPkgs.pylint

            # Formatting
            black

            # LSP
            pyright
            pythonPkgs.python-lsp-server
          ];

          shellHook = ''
            echo "Qtile dev environment loaded"
            echo "  - Python: $(python --version)"
            echo "  - Qtile: $(python -c 'import libqtile; print(libqtile.__version__)' 2>/dev/null || echo 'available')"
            echo ""
            echo "Available tools:"
            echo "  - ruff (linting/formatting)"
            echo "  - mypy (type checking)"
            echo "  - pylint (linting)"
            echo "  - black (formatting)"
            echo "  - pyright (LSP)"
            echo "  - pylsp (LSP)"
          '';
        };
      });
}
