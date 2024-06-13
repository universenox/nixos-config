{ config, lib, pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
  services.desktopManager.plasma6.enable = true;

  # notice that some glyphs are just missing otherwise
  fonts = {
    enableDefaultPackages = true;
  };
}
