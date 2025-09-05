{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  modulesPath,
  ...
}@args:
let
  osSteamEnabled = args.osConfig.programs.steam.enable or false;
  steamPackage = if !osSteamEnabled then args.osConfig.programs.steam.package else pkgs.steam;
  defaultWine = pkgs-unstable.proton-ge-bin;
in
{
  disabledModules = [
    "${modulesPath}/programs/lutris.nix"
  ];
  imports = [
    ../modules/home-manager/lutris.nix
  ];
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
    defaultWinePackage = defaultWine;
    winePackages = [
      inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
      pkgs.wineWowPackages.stagingFull
      pkgs.wineWowPackages.stableFull
    ];
    protonPackages = [ defaultWine ];
    runners = {
      ryujinx.package = pkgs-unstable.ryubing;
      cemu.package = pkgs-unstable.cemu;
    };
  };
  home.packages = [
    (pkgs.prismlauncher.override {
      jdks = with pkgs; [
        openjdk21
        openjdk24
        openjdk8
      ];
    })

  ];
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
