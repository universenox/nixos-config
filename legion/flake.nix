{
  description = "My System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # for suggesting pkgs when not found
    flake-programs-sqlite.url = "github:wamserma/flake-programs-sqlite";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.legion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (import ./configuration.nix)
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
      ];
    };
  };
}
