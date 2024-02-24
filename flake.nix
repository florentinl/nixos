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

  outputs = inputs@{ nixpkgs, lanzaboote, nixpkgs-unstable, ... }:
    let
      makeConfiguration = { hostname, platform, user }:
        let
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${platform};
        in
        {
          "${hostname}" = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit pkgs-unstable; inherit hostname; inherit user; };
            system = platform;
            modules = [
              lanzaboote.nixosModules.lanzaboote
              ./config # Generic NixOS configuration
              ./devices/${hostname}.nix # Device-specific configuration
            ];
          };
        };
      user = {
        name = "florentinl";
        isNormalUser = true;
        description = "Florentin Labelle";
        extraGroups = [ "networkmanager" "wheel" ];
      };
    in
    {
      nixosConfigurations =
        makeConfiguration { hostname = "flaptop"; platform = "x86_64-linux"; user = user; } //
        makeConfiguration { hostname = "bsport"; platform = "x86_64-linux"; user = user; };
    };
}
