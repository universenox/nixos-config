{ lib, config, pkgs, ... }:
{
  # NOTE: gamescope does not work with mouse at the moment.
  # it may require disabling mouse acceleration.
 
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.steam = {
     enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
   };

  environment.systemPackages = with pkgs; [
    (steam.override {
       # withPrimus = true; # deprecated? gives error.
       extraPkgs = pkgs: [ bumblebee glxinfo ];
     }).run
     gamescope
  ];

  # gamescope
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };
}
