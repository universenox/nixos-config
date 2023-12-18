{ esp_mount }:
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3fa63a44-941e-4d93-82c0-1e866ae63c9c";
      fsType = "ext4";
    };
  fileSystems."${esp_mount}" = { device = "/dev/disk/by-uuid/CA93-24DB";
      fsType = "vfat";
    };

    # systemd fills up my boot partition with old kernels, so
    # use grub and let the kernels live in my root partition.
    boot = let kernpkgs = pkgs.linuxPackages_latest; in {
      kernelPackages = kernpkgs;
      kernelModules = [ "kvm-intel" "acpi_call"];
      extraModulePackages = with kernpkgs; [ acpi_call ];

      initrd = {
          availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" ];
          kernelModules = [ ];
      };
      loader = {
        efi = {
          canTouchEfiVariables = true; 
          efiSysMountPoint = esp_mount;
        };
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true; # detects and inserts windows entry
          extraEntries = ''
          menuentry "Reboot" {
              reboot
          }
          menuentry "Shut Down" {
              halt
          }
          '';
        };
      systemd-boot.enable = false;
    };
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = "nixos"; 
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  hardware = let redistFw = true; in {
    enableRedistributableFirmware = redistFw;
    cpu.intel.updateMicrocode = redistFw;
    opengl.extraPackages = with pkgs; [
        vaapiVdpau
    ];

    nvidia = {
        modesetting.enable = true; # required
        powerManagement.enable = true; # expiriment
        open = true;
        nvidiaSettings = true;

        prime = {
          #sync.enable = true;
          # offload breaks my battery?
          offload = let enable = true; in {
            enable = enable;
            enableOffloadCmd = enable; # Provides `nvidia-offload` command.
          };
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Power, non-nvidia:
  services.thermald.enable = lib.mkForce true;

  # tlp conflicts with power profiles daemon
  services.tlp.enable = lib.mkForce true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  swapDevices = [ ];
}
