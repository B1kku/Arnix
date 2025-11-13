{
  pkgs,
  ...
}:
let
  rebind-protection = ''
    # Localhost rebinding protection
    0.0.0.0
    127.*

    # RFC1918 rebinding protection
    10.*
    ${(pkgs.lib.range 16 31) |> map (n: "172.${toString n}.*") |> pkgs.lib.concatStringsSep "\n"}
    192.168.*
  '';

in
{
  networking = {
    nameservers = [
      "127.0.0.1"
    ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      server_names = [ "ctrld" ];
      http3 = true;

      block_ipv6 = true;

      blocked_ips.blocked_ips_file = pkgs.writeTextFile {
        name = "blocked-ips.txt";
        text = rebind-protection;
      };
      static = {
        ctrld.stamp = "sdns://AgcAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tGS9uby1wb3JuLWFkcy1tYWx3YXJlLXR5cG8";
      };
    };
  };
}
