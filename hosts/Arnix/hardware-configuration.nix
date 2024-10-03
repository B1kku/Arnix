# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
let ssd-options = [ "noatime" "nodiratime" "discard" ];
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "ext4";
    options = ssd-options;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/Home";
    fsType = "ext4";
    options = ssd-options;
  };

  fileSystems."/run/media/bikku/Data-HDD" = {
    device = "/dev/disk/by-label/Data-HDD";
    fsType = "ext4";
  };

  fileSystems."/run/media/bikku/Data-SSD" = {
    device = "/dev/disk/by-label/Data-SSD";
    fsType = "ext4";
    options = ssd-options;
  };
  swapDevices = [{
    device = "/var/lib/swapfile";
    # RedHat recommends 0.5/1.5 * RAM depending on whether hibernation is on or off
    size = builtins.ceil(0.5 * 16 * 1024);
    randomEncryption.enable = true;
  }];
  zramSwap.enable = true;
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # Why the hell was this by default. Am I missing something?
  # And why knowing this is off by default had me going through a trail of options.
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  # lib.mkDefault config.hardware.enableRedistributableFirmware;
}
