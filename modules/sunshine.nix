{ ... }:
{
  networking.firewall =
    let
      port = 47989;
      generatePorts = port: offsets: map (offset: port + offset) offsets;
    in
    {
      allowedLocalTCPPorts = generatePorts port [
        (-5)
        0
        1
        21
      ];
      allowedLocalUDPPorts = generatePorts port [
        9
        10
        11
        13
        21
      ];
    };
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
  };
}
