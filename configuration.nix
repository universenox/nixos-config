# configuration.nix(5) man page
# NixOS manual (accessible by running ‘nixos-help’).
{ lib, config, pkgs, modulesPath, programs-sqlite-db, ... }:
{
  imports = [
    ./LL740-boot-fs.nix
    ./LL740-power-nvidia.nix
    ./locale.nix
    ./sound.nix
    ./display-manager.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05"; # no touchy
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim_configurable
    wget
    curl
    git
    htop
    lshw
    home-manager
  ];

  environment.variables.EDITOR = "vim";
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  programs.mtr.enable = true;
  programs.zsh.enable = true;

  users.users.kim = {
    isNormalUser = true;
    description = "Kimberly Swanson";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  services.printing.enable = true;
}
