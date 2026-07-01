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
  lutrisPackage = pkgs-unstable.lutris.override (prev: {
    buildFHSEnv =
      args:
      prev.buildFHSEnv (
        args
        // {
          profile = ''
            export TZ=${args.osConfig.time.timeZone or "Europe/Brussels"}
          '';
        }
      );
  });
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
    package = lutrisPackage;
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
    runners = {
      ryujinx.package = pkgs-unstable.ryubing;
      yuzu.package = pkgs-unstable.eden;
      cemu.package = pkgs.cemu;
      wine = {
        packages = with pkgs; [
          wineWow64Packages.stagingFull
          wineWow64Packages.stableFull
          pkgs.proton-ge-bin
        ];
        defaultPackage = defaultWine;
        settings.system.env = {
          PROTON_NO_WM_DECORATION = 1;
        };
      };
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
