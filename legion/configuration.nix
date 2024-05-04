# configuration.nix(5) man page
# NixOS manual (accessible by running ‘nixos-help’).
{ lib, config, pkgs, ... }:
{
  imports = [
    ./boot-fs.nix
    ./nvidia-power.nix
    ./locale.nix
    ./sound.nix
    ./display-manager.nix
    ./steam.nix
    ../custom_cfg.nix
  ];
  custom_cfg.user = "kim";
  custom_cfg.enableTailscaleClient = true;
  custom_cfg.enableSyncthingClient = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05"; # no touchy
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim_configurable
    helix

    git
    wget
    curl
    lshw
    home-manager

  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  environment.variables.EDITOR = "hx";
  networking = {
    hostName = "legion";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  programs.mtr.enable = true;
  programs.zsh.enable = true;

  users.users.kim = {
    isNormalUser = true;
    description = "Kimberly Swanson";
    extraGroups = [ "networkmanager" "wheel" "nginx" ];
    shell = pkgs.zsh;
  };
  services.printing.enable = true;
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [
      "--login-server"
      "https://headscale.mycute.cafe:443"
      "--accept-routes"
    ];
  };
}
