{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}@args:
let
  osSteamEnabled = args.osConfig.programs.steam.enable or false;
  steamPackage = if !osSteamEnabled then args.osConfig.programs.steam.package else pkgs.steam;
in
{
  programs.lutris = {
    enable = true;
    steamPackage = steamPackage;
    extraPackages =
      with pkgs-unstable;
      [
        umu-launcher
      ]
      ++ (with pkgs; [
        mangohud
        winetricks
      ]);
    winePackages = [
      inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
      pkgs.wineWowPackages.stagingFull
      pkgs.wineWowPackages.stableFull
    ];
    protonPackages = [ pkgs-unstable.proton-ge-bin ];
    runners = {
      ryujinx.package = pkgs-unstable.ryubing;
      cemu.package = pkgs-unstable.cemu;
    };
  };
  # Allows starting up steam on the background on gnome.
  xdg.desktopEntries.steam-background = lib.mkIf osSteamEnabled {
    name = "Steam Background";
    exec = "steam -silent %u";
    icon = "steam";
    categories = [
      "Network"
      "FileTransfer"
      "Game"
    ];
  };
}
