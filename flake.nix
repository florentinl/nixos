{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, lanzaboote, ... }:
    let
      makeConfiguration = { hostname, platform, user }:
        {
          "${hostname}" = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit hostname; inherit user; };
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
