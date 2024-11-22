{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    types
    mkOption
    mkIf
    ;
  cfg = config.networking.firewall;
  canonicalizePortList = ports: lib.unique (builtins.sort builtins.lessThan ports);
  getDescription = range: type: ''
    ${range} of ${type} ports on which incoming local connections are
     accepted.
  '';
in
{
  options.networking.firewall = {
    allowedLocalUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      apply = canonicalizePortList;
      example = [
        22
        80
      ];
      description = getDescription "List" "UDP";
    };
    allowedLocalTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      apply = canonicalizePortList;
      example = [ 53 ];
      description = getDescription "List" "TCP";
    };
    allowedLocalUDPPortRanges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
      example = [
        {
          from = 60000;
          to = 61000;
        }
      ];
      description = getDescription "Range" "UDP";
    };
    allowedLocalTCPPortRanges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
      example = [
        {
          from = 60000;
          to = 61000;
        }
      ];
      description = getDescription "Range" "TCP";
    };
  };

  config = mkIf (cfg.enable && cfg.package.pname == "iptables") {
    networking = {
      firewall =
        let
          chainLocalPort = (
            add: type: port:
            "iptables ${if add then "-A" else "-D"} nixos-fw -p ${type} --source 192.168.1.0/24 --dport ${toString port} -j nixos-fw-accept"
          );
          chainLocalPortRange = (
            add: type: portAttr:
            chainLocalPort add type "${toString portAttr.from}:${toString portAttr.to}"
          );
        in
        {
          extraCommands =
            builtins.concatLists [
              (cfg.allowedLocalTCPPorts |> map (chainLocalPort true "TCP"))
              (cfg.allowedLocalUDPPorts |> map (chainLocalPort true "UDP"))
              (cfg.allowedLocalTCPPortRanges |> map (chainLocalPortRange true "TCP"))
              (cfg.allowedLocalUDPPortRanges |> map (chainLocalPortRange true "UDP"))
            ]
            |> concatStringsSep "\n";
          extraStopCommands =
            builtins.concatLists [
              (cfg.allowedLocalTCPPorts |> map (chainLocalPort false "TCP"))
              (cfg.allowedLocalUDPPorts |> map (chainLocalPort false "UDP"))
              (cfg.allowedLocalTCPPortRanges |> map (chainLocalPortRange false "TCP"))
              (cfg.allowedLocalUDPPortRanges |> map (chainLocalPortRange false "UDP"))
            ]
            |> map (command: command + " || true")
            |> concatStringsSep "\n";
        };
    };
  };
}
