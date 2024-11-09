{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  osConfig,
  ...
}: {
  programs.lutris = {
    enable = true;
    winePackages = [
      pkgs.wineWowPackages.stableFull
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    ];
    runners = [
      pkgs.ryujinx
      pkgs.cemu
    ];
  };
  home.packages = with pkgs-unstable; [
    steam-run
    winetricks
    wineWowPackages.stableFull
  ];
}
