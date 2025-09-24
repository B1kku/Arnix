{
  username,
  ...
}:
{
  boot.kernelModules = [ "kvm-amd" ];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" ];
}
