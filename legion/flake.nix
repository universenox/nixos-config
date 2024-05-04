{
  description = "My System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:universenox/nixpkgs/syncthing_more";

    # for suggesting pkgs when not found
    flake-programs-sqlite.url = "github:wamserma/flake-programs-sqlite";
    flake-programs-sqlite.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; nixpkgs.config.allowUnfree = true; };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations.legion = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (import ./configuration.nix)
          inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        ];
      };
    };
}
