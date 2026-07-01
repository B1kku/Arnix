{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    optional
    nameValuePair
    mapAttrs'
    filterAttrsRecursive
    toLower
    listToAttrs
    getExe
    ;
  cfg = config.programs.lutris;
  settingsFormat = pkgs.formats.yaml { };
  formatWineName = (package: toLower package.name);
in
{
  options.programs.lutris = {
    enable = mkEnableOption "lutris.";
    package = lib.mkPackageOption pkgs "lutris" { };
    steamPackage = mkOption {
      default = null;
      example = "pkgs.steam or osConfig.programs.steam.package";
      description = ''
        This must be the same you use for your system, or two instances will conflict,
        for example, if you configure steam through the nixos module, a good value is "osConfig.programs.steam.package"
      '';
      type = types.nullOr types.package;
    };
    extraPackages = mkOption {
      default = [ ];
      example = "with pkgs; [mangohud winetricks gamescope gamemode umu-launcher]";
      description = ''
        List of packages to pass as extraPkgs to lutris.
        Please note runners are not detected properly this way, use a proper option for those.
      '';
      type = types.listOf types.package;
    };
    runners =
      let
        runnerSettings = mkOption {
          default = { };
          description = ''
            Settings passed directly to lutris for this runner's config at XDG_CONFIG/lutris/runners.
          '';
          type = types.submodule {
            options = {
              runner = mkOption {
                default = { };
                description = ''
                  Runner specific options.
                  For references, you must look for the file of said runner on lutris' source code.
                '';
                type = types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    runner_executable = mkOption {
                      type = types.either types.str types.path;
                      default = "";
                      description = ''
                        Specific option to point to a runner executable directly, don't set runner.package if you set this.
                        Uncompatible with certain runners such as wine.
                      '';
                    };
                  };
                };
              };
              system = mkOption {
                default = { };
                description = ''
                  Lutris system options for this runner.
                  Reference for system options:
                  https://github.com/lutris/lutris/blob/master/lutris/sysoptions.py#L78
                '';
                type = types.submodule { freeformType = settingsFormat.type; };
              };
            };
          };
        };
        genericRunner =
          { config, ... }:
          {
            options = {
              package = mkOption {
                default = null;
                example = "pkgs.cemu";
                description = ''
                  The package to use for this runner, nix will try to find the executable for this package.
                  A more specific path can be set by using settings.runner.runner_executable instead.
                '';
                type = types.nullOr types.package;
              };
              settings = runnerSettings;
            };
            config.settings.runner.runner_executable = mkIf (config.package != null) (
              lib.mkDefault (getExe config.package)
            );
          };
        wineRunner =
          { config, ... }:
          {
            options = {
              packages = mkOption {
                default = [ ];
                example = "[ pkgs.wineWow64Packages.full pkgs.proton-ge-bin ]";
                type = types.listOf types.package;
                description = ''
                  List of wine (and proton) packages to add to lutris.
                '';
              };
              defaultPackage = mkOption {
                default = null;
                example = "pkgs.proton-ge-bin";
                type = types.nullOr types.package;
                description = ''
                  Wine (or proton) package to use by default for lutris.
                  Do not add this to packages.
                '';
              };
              settings = runnerSettings;
            };
            config = {
              settings.runner.version = mkIf (config.defaultPackage != null) (
                lib.mkDefault (formatWineName config.defaultPackage)
              );
            };
          };
      in
      mkOption {
        default = { };
        example = ''
          runners = {
            cemu.package = pkgs.cemu;
            pcsx2.config = {
              system.disable_screen_saver = true;
              runner.runner_executable = "$\{pkgs.pcsx2}/bin/pcsx2-qt";
            };
          };
        '';
        description = ''
          Attribute set of Lutris runners along with their configurations.
          Each runner must be named exactly as lutris expects on `lutris --list-runners`.
          Note that runners added here won't be configurable through Lutris using the GUI.
        '';

        type = types.submodule {
          freeformType = types.attrsOf (types.submodule genericRunner);
          options.wine = mkOption {
            default = { };
            type = types.submodule wineRunner;
          };
        };
      };
  };
  meta.maintainers = [ lib.hm.maintainers.bikku ];
  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "programs.lutris" pkgs lib.platforms.linux)
      (lib.hm.assertions.assertPlatform "programs.lutris" pkgs lib.platforms.x86_64)
    ];
    home.packages =
      let
        lutris-overrides = {
          # This only adds pkgs.steam to the extraPkgs, I see no reason to ever enable it.
          steamSupport = false;
          extraPkgs = (prev: cfg.extraPackages ++ optional (cfg.steamPackage != null) cfg.steamPackage);
        };
      in
      [ (cfg.package.override lutris-overrides) ];

    xdg.configFile =
      let
        buildRunnerConfig = (
          runner_name: runner_config:
          # Remove the unset values so they don't end up on the final config.
          filterAttrsRecursive (name: value: value != { } && value != null && value != "") {
            "${runner_name}" = runner_config.settings.runner;
            inherit (runner_config.settings) system;
          }
        );
      in
      mapAttrs' (
        runner_name: runner_config:
        nameValuePair "lutris/runners/${runner_name}.yml" {
          source = settingsFormat.generate "${runner_name}.yml" (buildRunnerConfig runner_name runner_config);
        }
      ) cfg.runners;

    xdg.dataFile =
      let
        differentiatesWine = lib.versionOlder cfg.package.version "0.5.20";
        winePackageTypes = map (
          e:
          if e ? steamcompattool then
            {
              type = if differentiatesWine then "proton" else "wine";
              package = e.steamcompattool;
            }
          else
            {
              type = "wine";
              package = e;
            }
        ) (cfg.runners.wine.packages ++ [ cfg.runners.wine.defaultPackage ]);
      in
      listToAttrs (
        map (
          # lutris seems to not detect wine/proton if the name has some caps
          { type, package }:
          (nameValuePair "lutris/runners/${type}/${formatWineName package}" {
            source = package;
          })
        ) winePackageTypes
      );
  };
}
