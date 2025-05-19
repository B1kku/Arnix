{
  config,
  pkgs,
  inputs,
  flake-opts,
  lib,
  ...
}:
{
  # For a clean seamless boot, there's at least one screen flicker, when driver
  # starts, but KMS (amdgpu) pushes plymouth start around 10s later, for it to show for 2s.
  # "plymouth.use-simpledrm" is supposed to mitigate this, it doesn't.
  # So my choice is to not use KMS, so at least plymouth is up for most of the loading
  # and push the flicker and driver load right before the DM, at least you get a cool animation.
  # For this, GRUB must load at the same resolution as the monitor and kms musn't be enabled.
  boot = {
    plymouth = {
      enable = true;
    };
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
      "bgrt_disable" # Remove vendor logo
    ];
    initrd.verbose = false;
  };
}
