{
  username,
  pkgs,
  ...
}:
{
  boot.kernelModules = [ "kvm-amd" ];
  virtualisation = {
    libvirtd = {
      qemu = {
        package = pkgs.qemu_full;
        ovmf.packages = [
          pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd # AAVMF
          pkgs.OVMF.fd
          pkgs.OVMFFull
        ];
      };
      enable = true;
    };
    spiceUSBRedirection.enable = true;

  };
  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

}
