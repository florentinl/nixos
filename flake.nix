{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
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
            specialArgs =
              let
                hardwareModules = nixos-hardware.nixosModules;
              in
              {
                inherit hostname;
                inherit user;
                inherit hardwareModules;
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
