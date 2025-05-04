{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  osConfig,
  ...
}@args:
{
  programs.lutris = {
    enable = true;
    steamPackage = osConfig.programs.steam.package;
    extraPackages =
      with pkgs-unstable;
      [
        winetricks
        umu-launcher
      ]
      ++ (with pkgs; [ mangohud ]);
    winePackages = [
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
      pkgs-unstable.wineWowPackages.full
    ];
    protonPackages = [ pkgs-unstable.proton-ge-bin ];
    runners = {
      ryujinx.package = pkgs-unstable.ryubing;
      cemu.package = pkgs-unstable.cemu;
    };
  };
  # Allows starting up steam on the background on gnome.
  xdg.desktopEntries.steam-background = lib.mkIf (args ? osConfig && osConfig.programs.steam.enable) {
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
