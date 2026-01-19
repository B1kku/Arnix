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
  defaultWine = pkgs.proton-ge-bin;
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
        (umu-launcher.override {
          extraProfile = ''
            unset TZ
          '';
        })
      ]
      ++ (with pkgs; [
        mangohud
        winetricks
      ]);
    defaultWinePackage = defaultWine;
    winePackages = [
      pkgs.wineWowPackages.stagingFull
      pkgs.wineWowPackages.stableFull
    ];
    protonPackages = [ defaultWine pkgs-unstable.proton-ge-bin ];
    runners = {
      ryujinx.package = pkgs-unstable.ryubing;
      cemu.package = pkgs.cemu;
    };
  };
  home.packages = [
    (pkgs.prismlauncher.override {
      jdks = with pkgs; [
        openjdk21
        openjdk25
        openjdk17
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
