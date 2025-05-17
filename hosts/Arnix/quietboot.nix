{
  config,
  pkgs,
  inputs,
  flake-opts,
  lib,
  ...
}:
{
  boot = {
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [ pkgs.nixos-bgrt-plymouth ];
      extraConfig = ''
        UseFirmwareBackground=false
      '';
    };
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
      "bgrt_disable"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
