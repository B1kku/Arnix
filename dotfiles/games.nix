{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  osConfig,
  ...
}@args :
{
  programs.lutris = {
    enable = true;
    winePackages = [
      pkgs.wineWowPackages.stableFull
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    ];
    protonPackages = [
      pkgs.proton-ge-bin
    ];
    runners = [
      pkgs.ryujinx
      pkgs.cemu
    ];
  };
  # Allows starting up steam on the background on gnome.

  xdg.desktopEntries.steam-background = lib.mkIf (args ? osConfig && osConfig.programs.steam.enable)  {
    name = "Steam Background";
    exec = "steam -silent %u";
    icon = "steam";
    categories = [
      "Network"
      "FileTransfer"
      "Game"
    ];
  };
  home.packages = with pkgs-unstable; [
    steam-run
    winetricks
    wineWowPackages.stableFull
  ];
}
