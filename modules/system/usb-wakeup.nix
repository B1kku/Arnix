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
    refreshRules = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, a refresh of all udev rules will be done
        after a short while during the boot process to try and
        combat race conditions and other things from overriding them.
      '';
    };
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
  config = mkIf (cfg.enable && (cfg.devices |> builtins.attrNames |> builtins.length) > 0) {
    # Copied as much as possible from systemd-udev-trigger.service
    systemd.services.udev-usb-refresh = mkIf cfg.refreshRules {
      wantedBy = [ "basic.target" ];
      after = [ "systemd-udev-trigger.service" ];
      unitConfig = {
        RequiresMountsFor = "/sys";
        DefaultDependencies = "no";
      };
      # Idk how to fully disable environment.
      environment = {
        PATH = lib.mkForce null;
        LOCALE_ARCHIVE = lib.mkForce null;
        TZDIR = lib.mkForce null;
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "udevadm trigger --subsystem-match=usb";
        RemainAfterExit = true;
      };
    };
    services.udev.packages =
      let
        baseRule = [
          ''ACTION=="add|change"''
          ''SUBSYSTEM=="usb"''
          ''DRIVERS=="usb"''
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
          cfg.devices
          |> mapAttrsToList deviceTarget
          |> map (filterRule: concatStringsSep ", " (baseRule ++ filterRule ++ (ruleAction action)))
        );
        # Contains which action to take depending on the mode set.
        # I assume if nix is lazy it won't calculate both.
        modeAction = {
          # Disable all, add rules below to enable those devices.
          whitelist = [ (concatStringsSep ", " (baseRule ++ ruleAction "disabled")) ] ++ (mapRules "enabled");
          blacklist = mapRules "disabled";
        };
      in
      [
        (
          [
            "# USB wakeup rules, controls which USB device can resume the computer from sleep."
            "# Do not change manually, use hardware.usb.wakeup to configure these."
          ]
          ++ modeAction.${cfg.mode}
          |> concatStringsSep "\n"
          #Append \n as EOL, writeTextDir did not seem to do this and I suspect that caused it to not work at times.
          |> (text: text + "\n")
          |> pkgs.writeTextDir "etc/udev/rules.d/99-usb-wakeup-configure.rules"
        )
      ];
  };
}
