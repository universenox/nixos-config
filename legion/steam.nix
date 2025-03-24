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
    # extraPackages = with pkgs;[
    #   mangohud
    #   gamescope
    # ];
  };
}
