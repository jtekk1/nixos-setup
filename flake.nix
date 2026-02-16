{
  description = "Core Flake for JTekk.Dev";

  inputs = {

    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    nixpkgs-stable = { url = "github:NixOS/nixpkgs/nixos-25.11"; };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
  };

  outputs = { self, nixpkgs, home-manager, colmena, sops-nix, disko
    , nixos-hardware, ... }@inputs:

    let
      lib = nixpkgs.lib;
      system_arch = "x86_64-linux";

      desktopEnvironments = [ "mango" ];

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
        home-manager.users.jtekk = import ./home-manager;
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
              jtekk.desktop-env = "mango";
            })

            # Specialisations
            {
              specialisation = {
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
          extraSpecialArgs = {
            inherit inputs theme isDesktop;
            osConfig = null;
          };
          modules = [ ./home-manager ];
        };

    in {

      # Standalone home-manager configurations
      homeConfigurations = {
        "jtekk" = mkHome { };
      } // lib.genAttrs (map (t: "jtekk-${t}") themes) (name:
        let theme = lib.removePrefix "jtekk-" name;
        in mkHome { inherit theme; });

      nixosConfigurations = let
        mkThemedConfigs = hostname:
          lib.genAttrs (map (t: "${hostname}-${t}") themes) (name:
            let theme = lib.removePrefix "${hostname}-" name;
            in mkSystem { inherit hostname theme; });
      in {

        # Desktop configuration (default theme)
        "deepspace" = mkSystem { hostname = "deepspace"; };
        "thinkpad" = mkSystem { hostname = "thinkpad"; };
        "deli" = mkSystem { hostname = "deli"; };

        # Server configurations
        # Only used as part of initial setups (nixos-anywhere)
        "beelink" = mkServer { hostname = "beelink"; };
        "mini-me" = mkServer { hostname = "mini-me"; };
        "tank" = mkServer { hostname = "tank"; };
      } // (mkThemedConfigs "deepspace") // (mkThemedConfigs "thinkpad")
      // (mkThemedConfigs "deli");

      colmena = import ./hive.nix {
        inherit nixpkgs home-manager disko inputs system_arch;
      };
    };
}
