{
  description = "My System Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  
  # for suggesting pkgs when not found
  inputs.flake-programs-sqlite.url = "github:wamserma/flake-programs-sqlite";
  inputs.flake-programs-sqlite.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs@{ self, nixpkgs, ... }: 
   let 
     system = "x86_64-linux";
     pkgs = import nixpkgs { inherit system; config.allowUnfree = true; }; 
     lib = nixpkgs.lib;
   in
   {
     nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
       inherit system;
       modules = [ 
	       (import ./configuration.nix)
	       inputs.flake-programs-sqlite.nixosModules.programs-sqlite
       ];
    };
  };
}
