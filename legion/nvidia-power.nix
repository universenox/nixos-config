{ config, lib, pkgs, ... }:
{
  powerManagement.powertop.enable = true;
  powerManagement.enable = true;

  boot.extraModulePackages = [
    #config.boot.kernelPackages.lenovo-legion-module
  ];
  #boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ]; # error in journalctl otherwise
  # nixpkgs.config.packageOverrides = pkgs: {
  #   vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  # };

  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;

      # idk but things can break easily with this.
      # https://wiki.archlinux.org/title/Hardware_video_acceleration
      # see also the nixos manual
      extraPackages = with pkgs; [
        intel-media-driver
        #intel-ocl
        #intel-vaapi-driver
      ];
    };

    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    nvidia = {
      modesetting.enable = true; # required
      powerManagement.enable = true; # experimental
      # powerManagement.finegrained = true; # experimental; offload

      package = config.boot.kernelPackages.nvidia_x11_vulkan_beta;

      prime = {
        # offload.enable = true;
        # offload.enableOffloadCmd = true;
        sync.enable = true; # more power bc gpu always on, but don't have to explicitly offload.
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  #services.xserver.videoDrivers = [ "nvidia" ];
  services.thermald.enable = true;

  # tlp conflicts with power profiles daemon
  # services.tlp.enable = true;
  # services.power-profiles-daemon.enable = false;
}
