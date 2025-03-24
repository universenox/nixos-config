{ pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  services.xserver.enable = true;  
  services.displayManager.sddm.enable = true;  
  services.desktopManager.plasma6.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.dejavu_fonts
    ];
  };
}
