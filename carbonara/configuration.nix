# Edit this configuration file to define what should be installed on your system.  Help is available in the 
# configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ 
  imports = [
      ./hardware-configuration.nix 
      ../personal_cfg.nix
      ../custom_cfg.nix
  ];
  networking.hostName = "carbonara";
  system.stateVersion = "23.05"; # no touchy

  # Bootloader.
  boot.loader.systemd-boot.enable = true; 
  boot.loader.efi.canTouchEfiVariables = true;
}
