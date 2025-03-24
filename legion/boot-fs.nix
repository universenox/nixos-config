# systemd fills up my boot partition with old kernels, so
# use grub and let the kernels live in my root partition.
{ config, lib, pkgs, ... }:
let esp_mount = "/boot/efi"; in# repartition sometime?
{
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/3fa63a44-941e-4d93-82c0-1e866ae63c9c";
      fsType = "ext4";
    };
  fileSystems."${esp_mount}" = {
    device = "/dev/disk/by-uuid/CA93-24DB";
    fsType = "vfat";
  };

  boot = let kernpkgs = pkgs.linuxPackages; in {
    kernelPackages = kernpkgs;
    kernelModules = [ "kvm-intel" "v4l2loopback" ];
    extraModulePackages = with kernpkgs; [ v4l2loopback ];

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
}
