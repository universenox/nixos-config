{
  description = "My System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # for suggesting pkgs when not found
    flake-programs-sqlite.url = "github:wamserma/flake-programs-sqlite";
    flake-programs-sqlite.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.carbonara = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (import ./configuration.nix)
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
      ];
    };
  };
}
