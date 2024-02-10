{ inputs, pkgs, lib, ... }:
let
  custom-lutris = (pkgs.lutris.override {
    extraPkgs = pkgs:
      with pkgs; [
        wineWowPackages.stableFull
        gamemode
        mangohud
        winetricks
      ];
  });
  # Add any lutris extra runners here, can also configure with runner.config
  lutris-runners = with pkgs; {
    cemu.package = cemu;
    yuzu.package = yuzu-early-access;
  };
in {
  xdg.configFile = lib.attrsets.mapAttrs' (name: value: {
    name = "lutris-${name}";
    value = let
      config = (lib.recursiveUpdate {
        system = {
          locale = "";
          disable_runtime = true;
        };
        ${name} = { runner_executable = lib.getExe value.package; };
      } (lib.optionalAttrs (value ? "config") value.config));
    in {
      target = "lutris/runners/${name}.yml";
      text = builtins.toJSON config;
    };
  }) lutris-runners;

  home.packages = with pkgs; [
    custom-lutris
    winetricks
    wineWowPackages.stableFull
    steam-run
  ];
}
