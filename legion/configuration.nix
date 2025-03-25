# configuration.nix(5) man page
# NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, lib, ... }:
{
  imports = [
    ../modules
    ../common.nix
    ./boot-fs.nix
    ./nvidia-power.nix
    ./locale.nix
    ./sound.nix
    ./display-manager.nix
    ./steam.nix
  ];

  # for playing around with pinned threads, benchmarks.
  boot.kernelParams = [
    # "isolcpus=0,1"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05"; # no touchy
  networking.hostName = "legion";
}
