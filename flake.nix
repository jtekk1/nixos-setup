{
  description = "Core Flake for JTekk.Dev";

  inputs = {

    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    nixpkgs-stable = { url = "github:NixOS/nixpkgs/nixos-25.11"; };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.52.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowc = {
      url = "github:DreamMaoMao/mangowc/0.10.7";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qtile = {
      url = "github:qtile/qtile";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cutacha = {
      url = "git+https://git.jtekk.dev/TekkOS/cutacha";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, colmena, sops-nix, disko, ... }@inputs:

    let
      lib = nixpkgs.lib;
      system_arch = "x86_64-linux";

      desktopEnvironments = [ "mango" "cosmic" "hyprland" ];

      # All available themes (imported from theme-configs.nix)
      themes = import ./theme-configs.nix;

      baseModules = hostname: [
        ./modules/desktop.nix
        ./modules/software.nix
        { nixpkgs.hostPlatform = system_arch; }
        ./hosts/${hostname}/configuration.nix
        home-manager.nixosModules.home-manager
      ];

      homeManagerConfig = theme: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-bak";
        home-manager.extraSpecialArgs = { inherit inputs theme; };
        home-manager.users.jtekk = import ./home;
      };

      mkSystem =
        { hostname, theme ? "nightfox", desktops ? desktopEnvironments }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs theme; };

          modules = baseModules hostname ++ [
            ./software
            ./system/core
            ./system/desktops
            (homeManagerConfig theme)

            ({ pkgs, ... }: {
              nixpkgs.overlays =
                [ (import ./overlays/custom-fixes.nix inputs) ];
              jtekk.desktop-env = "desktop";
            })

            # Specialisations
            {
              specialisation = {
                mango-hypr.configuration = {
                  jtekk.desktop-env = "mango-hypr";
                };
                openrgb.configuration = {
                  jtekk.software.openrgb.enable = true;
                };
                teamviewer.configuration = {
                  jtekk.software.teamviewer.enable = true;
                };
              };
            }
          ];
        };

      mkServer = { hostname }:
        let networkConfig = import ./network-config.nix;
        in nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs networkConfig; };

          modules = baseModules hostname ++ [
            ./system/server
            ./system/core
            ./software/unfree.nix
            ./software/programming/containers.nix
            ./software/programming/dev.nix
            ./software/programming/git.nix
            disko.nixosModules.disko
            (homeManagerConfig "kanagawa")
            { jtekk.desktop-env = "server"; }
          ];
        };

      # Standalone home-manager configuration
      mkHome = { theme ? "nightfox", isDesktop ? true }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = system_arch;
            overlays = [ (import ./overlays/custom-fixes.nix inputs) ];
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs theme isDesktop; osConfig = null; };
          modules = [ ./home ];
        };

    in {

      # Standalone home-manager configurations
      homeConfigurations = {
        "jtekk" = mkHome { };
      } // lib.genAttrs (map (t: "jtekk-${t}") themes) (name:
        let theme = lib.removePrefix "jtekk-" name;
        in mkHome { inherit theme; });

      nixosConfigurations = {
        # Desktop configuration (default theme)
        "deepspace" = mkSystem { hostname = "deepspace"; };

        # Server configurations
        # Only used as part of initial setups (nixos-anywhere)
        "beelink" = mkServer { hostname = "beelink"; };
        "mini-me" = mkServer { hostname = "mini-me"; };
        "tank" = mkServer { hostname = "tank"; };
      } // lib.genAttrs (map (t: "deepspace-${t}") themes) (name:
        let theme = lib.removePrefix "deepspace-" name;
        in mkSystem {
          hostname = "deepspace";
          inherit theme;
        });

      colmena = import ./hive.nix {
        inherit nixpkgs home-manager disko inputs system_arch;
      };
    };
}
