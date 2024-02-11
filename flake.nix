{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, lanzaboote, nixpkgs-unstable, ... }: {
    nixosConfigurations =
      let
        system = "x86_64-linux";
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      in
      {
        flaptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit pkgs-unstable; };
          system = system;
          modules = [
            lanzaboote.nixosModules.lanzaboote
            ./config # Generic NixOS configuration
            ./devices/flaptop.nix # Device-specific configuration
          ];
        };
      };
  };
}
