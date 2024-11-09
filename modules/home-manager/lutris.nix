{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  cfg = config.programs.lutris;
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    optional
    toLower
    listToAttrs
    nameValuePair
    ;
  # TODO: Properly define this type.
  runnerType = types.submodule {
    options = {
      package = mkOption {type = types.package;};
    };
  };
in {
  options.programs.lutris = {
    enable = mkEnableOption "lutris";

    package = mkOption {
      type = types.package;
      default = pkgs.lutris;
    };

    steamPackage = mkOption {
      type = types.nullOr types.package;
      default =
        if (args ? osConfig) && args.osConfig.programs.steam.enable
        then args.osConfig.programs.steam.package
        else pkgs.steam;
      description = ''
        This must be the same you use for your system, or two instances will exist
                Default will try to pull steam from osConfig.programs.steam.package, else fallback to pkgs.steam'';
    };

    extraPkgs = mkOption {
      type = types.listOf types.package;
      default = (
        with pkgs; [
          gamemode
          mangohud
          winetricks
          gamescope
          libstrangle
        ]
      );
    };

    winePackages = mkOption {
      type = types.listOf types.package;
      default = [pkgs.wineWowPackages.stableFull];
    };

    runnersDefaultConfig = mkOption {
      type = types.attrs;
      default = {
        system = {
          locale = "";
          disable_runtime = true;
        };
      };
    };

    runners = mkOption {type = types.listOf (types.either types.package runnerType);};
  };
  config = mkIf cfg.enable {
    # Add custom lutris to the home packages.
    home.packages = let
      lutris-override = {
        # All this does is add their own non-overridable steam to extraPkgs.
        steamSupport = false;
        extraPkgs = pkgs: cfg.extraPkgs ++ optional (cfg.steamPackage != null) cfg.steamPackage;
      };
    in [(cfg.package.override lutris-override)];
    # Link wine packages, for some reason it trips out if there's any caps on the name.
    # Couldn't find a better way than linking the wine package to local/share.
    xdg.dataFile = listToAttrs (
      map (
        wine-pkg: let
          name = toLower wine-pkg.name;
        in (nameValuePair name {
          target = "lutris/runners/wine/${name}";
          source = wine-pkg;
        })
      )
      cfg.winePackages
    );
    # Link other runners.
    xdg.configFile = let
      pkgToRunner = (
        runner-package: {
          name = runner-package.pname;
          package = runner-package;
          config.runner_executable = lib.getExe runner-package;
          system = cfg.runnersDefaultConfig.system;
        }
      );
      runnerToConfig = (
        runner-config: let
          name = runner-config.name;
          config = {
            ${name} = runner-config.config;
            inherit (runner-config) system;
          };
        in {
          "lutris-${name}" = {
            target = "lutris/runners/${name}.yml";
            text = builtins.toJSON config;
          };
        }
      );
    in
      builtins.foldl' (
        acc: runner:
          acc
          // (
            if (types.package.check runner)
            then (runnerToConfig (pkgToRunner runner))
            else runnerToConfig runner
          )
      ) {}
      cfg.runners;
  };
}
