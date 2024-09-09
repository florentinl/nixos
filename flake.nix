{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      lanzaboote,
      ...
    }:
    let
      makeConfiguration =
        {
          hostname,
          platform,
          user,
        }:
        {
          "${hostname}" = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit hostname;
              inherit user;
            };
            system = platform;
            modules = [
              lanzaboote.nixosModules.lanzaboote
              ./config # Generic NixOS configuration
              ./devices/${hostname} # Device-specific configuration
            ];
          };
        };

      user = {
        name = "florentinl";
        isNormalUser = true;
        description = "Florentin Labelle";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = makeConfiguration {
        hostname = "flaptop";
        platform = "x86_64-linux";
        user = user;
      };
    };
}
