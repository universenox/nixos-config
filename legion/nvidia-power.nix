{ config, lib, pkgs, ... }:
{
  powerManagement.powertop.enable = true;
  powerManagement.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  programs.gamemode.enable = true;


  # TODO...
  hardware = {
    enableRedistributableFirmware = true;

    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    nvidia = {
      nvidiaSettings = true;
      open = true;
      modesetting.enable = true; # required
      powerManagement.enable = true; # experimental
      # powerManagement.finegrained = true; # experimental; offload
      # package = config.boot.kernelPackages.nvidia_x11_beta;

      # disabled intel gpu in bios bc windows wasn't "just werk"ing
      prime = {
        # offload.enable = true;
        # offload.enableOffloadCmd = true;
        sync.enable = true; # more power bc gpu always on, but don't have to explicitly offload.
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  services.thermald.enable = true;
}
