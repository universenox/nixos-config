{ config, lib, pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager.plasma5.enable = true;
  };
  services.displayManager.defaultSession = "plasmawayland";

  # notice that some glyphs are just missing otherwise
  fonts = {
    enableDefaultPackages = true;
  };
}
