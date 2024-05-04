{ config, pkgs, syncthing_port, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./ssh.nix
    ../custom_cfg.nix
    ./networking.nix
  ];
  custom_cfg.user = "kim";
  custom_cfg.tailscale_user = "vps";
  custom_cfg.enableTailscaleClient = true;
  custom_cfg.enableSyncthingClient = true;

  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  programs.gnupg.agent = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    helix
    home-manager
    openssl

    pass
    syncthing

    age
    gnupg
  ];

  programs.zsh.enable = true;
  users.users.kim = {
    isNormalUser = true;
    extraGroups = [ "wheel" config.services.nginx.group config.services.syncthing.group ];
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
