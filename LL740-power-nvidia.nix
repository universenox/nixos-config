{ config, lib, pkgs, ... }:
{
  powerManagement.powertop.enable = true;
  powerManagement.enable = true;

  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module config.boot.kernelPackages.nvidia_x11 ];
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true; # required
      powerManagement.enable = true; # experimental
      #powerManagement.finegrained = false; # experimental; offload

      prime = {
        #sync.enable = true;
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  services.thermald.enable = true;

  # tlp conflicts with power profiles daemon
  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;
}
