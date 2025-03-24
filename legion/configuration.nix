# configuration.nix(5) man page
# NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, lib, ... }:
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

  nix.settings.trusted-users = [
    "kim"
  ];

  # for playing around with pinned threads, benchmarks.
  boot.kernelParams = [
    # "isolcpus=0,1"
  ];
  
  custom_cfg.user = "kim";
  custom_cfg.enableTailscaleClient = true;
  custom_cfg.enableSyncthingClient = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05"; # no touchy
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim_configurable
    helix

    git
    wget
    curl
    lshw
    home-manager
    glxinfo
    wl-clipboard
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  
  hardware.keyboard.zsa.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "nginx" "plugdev" "gamemode" ];
    shell = pkgs.zsh;
  };
  services.printing.enable = true;
}
