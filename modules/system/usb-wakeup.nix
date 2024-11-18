# Adapted from: https://9999years/nix-config/
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mapAttrsToList
    concatStringsSep
    toLower
    types
    mkOption
    mkIf
    mkEnableOption
    ;
  cfg = config.hardware.usb.wakeup;
  vendorProductStrDesc = type: ''
    The device's ${type} ID, as a 4-digit hex string.

    ${type} IDs of USB devices can be listed with <code>nix-shell -p usbutils
    --run lsusb</code>, where an output line like <code>Bus 002 Device 003: ID
    046d:c52b Logitech, Inc. Unifying Receiver</code> has a vendor ID of
    <code>046d</code> and a product ID of <code>c52b</code>.

    All strings are converted to lowercase.
  '';
  deviceStr = types.strMatching "^[0-9a-fA-F]{4}$";
in
{
  options.hardware.usb.wakeup = {
    enable = mkEnableOption "USB wakeup rules";

    mode = mkOption {
      type = types.enum [
        "whitelist"
        "blacklist"
      ];
      default = "whitelist";
      description = ''
        Whitelist disables all devices but the ones specified from waking up the computer.
        (This means you're able to enable as whitelist without devices to disable all)
        Blacklist removes the ability of the listed devices to wake up the computer.
      '';
    };
    devices = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            product = mkOption {
              description = vendorProductStrDesc "product";
              type = deviceStr;
              example = "c52b";
            };
            vendor = mkOption {
              description = vendorProductStrDesc "vendor";
              type = deviceStr;
              example = "046d";
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages =
      let
        baseRule = [
          ''ACTION=="add"''
          ''SUBSYSTEM=="usb"''
          ''ATTRS{removable}=="removable"''
        ];
        deviceTarget = (
          name: device: [
            ''ATTRS{idVendor}=="${toLower device.vendor}"''
            ''ATTRS{idProduct}=="${toLower device.product}"''
          ]
        );
        ruleAction = action: [ ''ATTR{power/wakeup}="${action}"'' ];

        # Map each device to a string rule that targets said device, with given action (enabled/disabled).
        mapRules = (
          action:
          (map (filterRule: concatStringsSep ", " (baseRule ++ filterRule ++ (ruleAction action))) (
            mapAttrsToList deviceTarget cfg.devices
          ))
        );
        # Contains which action to take depending on the mode set.
        modeAction = {
          # Disable all, add rules below to enable those devices.
          whitelist = [ (concatStringsSep ", " (baseRule ++ ruleAction "disabled")) ] ++ (mapRules "enabled");
          blacklist = mapRules "disabled";
        };
        rules = modeAction.${cfg.mode};
      in
      if (builtins.length rules <= 0) then
        [ ]
      else
        [
          (pkgs.writeTextDir "etc/udev/rules.d/90-usb-wakeup-configure.rules" (
            (concatStringsSep "\n" (
              [ "#USB wakeup rules, controls which USB devices can resume the computer from sleep." ] ++ rules
            ))
            + "\n"
          ))
        ];
  };
}