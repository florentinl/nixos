{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {
      flaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config # Generic NixOS configuration
          ./devices/flaptop.nix # Device-specific configuration
          ./hardware-configuration.nix # Auto-generated hardware configuration
        ];
      };
    };
  };
}
