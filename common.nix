# Everything here should be NOT specific to hardware.
# System-level stuff that we want for personal machines.
{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "kim" ];
  };

  users.users.kim = {
    isNormalUser = true;
    description = "Kimberly Swanson";
    extraGroups = [ "networkmanager" "wheel" "nginx" "plugdev" "gamemode" ];
    shell = pkgs.zsh;
  };
  
  my.syncthing.user = "kim";
  my.syncthing.enable = true;

  environment.systemPackages = with pkgs; [
    vim_configurable
    helix
    git
    wget
    curl
    lshw
    home-manager
    glxinfo
    gnupg
    wl-clipboard
  ];
  environment.variables.EDITOR = "hx";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  
  hardware.keyboard.zsa.enable = true;

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  programs.mtr.enable = true;
  programs.zsh.enable = true;

  services.printing.enable = true;
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  security.rtkit.enable = true;
  services.pipewire.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
  services.displayManager.sddm.enable = true; 
  services.desktopManager.plasma6.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.dejavu_fonts
      pkgs.wl-clipboard
    ];
  };
}
