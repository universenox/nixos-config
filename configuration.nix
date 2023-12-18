# configuration.nix(5) man page
# NixOS manual (accessible by running ‘nixos-help’).
{ lib, config, pkgs, programs-sqlite-db, ... }:
let 
  esp_mount = "/boot/efi"; in
{
  imports =
    [
      (import ./my-lenovo-legion-y540.nix { esp_mount = esp_mount; })
      ./locale.nix
      ./sound.nix
      ./display-manager.nix
      ./packages.nix
    ];

  # man configuration.nix or https://nixos.org/nixos/options.html.
  system.stateVersion = "23.05"; # no touchy
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true; 

  services.printing.enable = true;

  users.users.kim = {
    isNormalUser = true;
    description = "Kimberly Swanson";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
