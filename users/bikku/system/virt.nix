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
      };
      enable = true;
    };
    spiceUSBRedirection.enable = true;

  };
  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

}
