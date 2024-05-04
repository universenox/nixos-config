{
  description = "VPS System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:universenox/nixpkgs/master";
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; nixpkgs.config.allowUnfree = true; };
      lib = nixpkgs.lib;

      syncthing_port = 5545;
    in
    {
      nixosConfigurations.vps = nixpkgs.lib.nixosSystem
        {
          inherit system;
          modules = [
            ./configuration.nix
            # sops-nix.nixosModules.sops
          ];
        };
    };
}
