{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./ssh.nix
    ./networking.nix
    ./syncthing.nix
  ];

  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  environment.systemPackages = with pkgs; [
    helix
    home-manager
    openssl

    age
    gnupg
    # ssh-to-age
    # sops
  ];

  programs.zsh.enable = true;
  users.users.kim = {
    isNormalUser = true;
    extraGroups = [ "wheel" config.services.nginx.group config.services.syncthing.group ];
    shell = "${pkgs.zsh}/bin/zsh";
  };

  # sops = {
  #   defaultSopsFile = ./sops.yaml;
  #   age.sshKeyPaths = [ "/etc/ssh/mycute.cafe" ];
  #   age.keyFile = "/etc/secrets/age/kimserv.txt";
  #   age.generateKey = false;

  #   secrets."syncthing-gui-pw" = {
  #     sopsFile = ./secrets/syncthing.yaml;
  #     owner = config.users.users.syncthing.name;
  #     group = config.users.groups.wheel.name;
  #   };
  # };
}
