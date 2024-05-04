{ lib, config, pkgs, ... }:
{
  # https://nixos.wiki/wiki/Steam
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

    # TODO: bumblebee pulls in older (broken) nvidia driver.
    # package = pkgs.steam.override {
    #   extraPkgs = pkgs: with pkgs; [ bumblebee glxinfo ];
    # };
  };
}
