{ config, lib, pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkb.layout = "us";
    videoDrivers = [ "nvidia" ];

    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  fonts = {
    enableDefaultPackages = true;   
  };
}
