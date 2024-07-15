{ inputs, pkgs, pkgs-unstable, lib, osConfig, ... }:
let
  custom-lutris = (pkgs-unstable.lutris.override {
    steamSupport = false;
    extraPkgs = pkgs-unstable:
      with pkgs-unstable; [
        osConfig.programs.steam.package
        gamemode # Tries to tune the system for games
        mangohud # For monitoring
        winetricks # For modifying wineprefix
        gamescope
        libstrangle # For limiting the fps
      ];
    # extraLibraries = pkgs-unstable: with pkgs-unstable; [ ];
  });
  # Add any lutris extra runners here, can also configure with runner.config
  lutris-runners = with pkgs-unstable; {
    cemu.package = pkgs.cemu; # Wouldn't work unstable, idk why.
    ryujinx.package = ryujinx; # RIP
  };
  # Any wine versions to link to lutris wines.
  # Remember to disable lutris runtime. 
  # Don't think it's worth it to configure the entirety of lutris just for that.
  wine-pkgs = with pkgs-unstable; [
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    wineWowPackages.stableFull
  ];
in {
  home.file = lib.listToAttrs (map (wine-pkg: {
    name = wine-pkg.name;
    value = {
      # Sue me if you want, lutris won't take multiple wine packages otherwise.
      target = ".local/share/lutris/runners/wine/${wine-pkg.name}";
      source = wine-pkg;
    };
  }) wine-pkgs);
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

  home.packages = with pkgs-unstable; [ custom-lutris steam-run winetricks wineWowPackages.stableFull ];
}
