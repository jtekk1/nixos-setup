{ nixpkgs, home-manager, disko, inputs, system_arch }:

let
  networkConfig = import ./network-config.nix;
  homelabHosts = import ./homelab/hosts.nix;

  # Shared home-manager configuration
  homeManagerConfig = theme: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.extraSpecialArgs = {
      inherit inputs;
      theme = theme;
    };
    home-manager.users.jtekk = import ./home;
  };

  # Create a colmena server configuration
  mkColmenaServer = { hostname, theme }: {
    deployment = {
      targetHost = networkConfig.hosts.${hostname}.ip;
      targetUser = "jtekk";
      targetPort = 22;
    };

    imports = [
      ./hosts/${hostname}/configuration.nix
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      (homeManagerConfig theme)
    ] ++ homelabHosts.${hostname};
  };

in {
  meta = {
    nixpkgs = import nixpkgs { localSystem = system_arch; };
    specialArgs = { inherit inputs networkConfig; };
  };

  defaults = { lib, ... }: {
    imports = [ ./modules/desktop.nix ];
    nixpkgs.hostPlatform = system_arch;
    deployment.privilegeEscalationCommand = [ "sudo" ];
    deployment.buildOnTarget = false;
    jtekk.desktop-env = "server";
    services.flatpak.enable = lib.mkForce false;
  };

  beelink = mkColmenaServer {
    hostname = "beelink";
    theme = "neuro-fusion";
  };
  mini-me = mkColmenaServer {
    hostname = "mini-me";
    theme = "icy-blue";
  };
  tank = mkColmenaServer {
    hostname = "tank";
    theme = "hakker";
  };
}
