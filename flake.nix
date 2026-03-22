{
  description = "Mi configuración con NixOS + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {
      # Configuración de NixOS
      nixosConfigurations.d4s = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/d4s/configuration.nix

          # Integración de Home Manager como módulo de NixOS
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.d4s = import ./home/home.nix;
          }
        ];
      };
    };
}
