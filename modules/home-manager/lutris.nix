{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}@args:
let
  cfg = config.programs.lutris;
  inherit (lib)
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
      package = mkOption { type = types.package; };
    };
  };
in
{
  options.programs.lutris = {
    enable = mkEnableOption "lutris";

    package = mkOption {
      type = types.package;
      default = pkgs.lutris;
    };

    steamPackage = mkOption {
      type = types.nullOr types.package;
      default =
        if (args ? osConfig) && args.osConfig.programs.steam.enable then
          args.osConfig.programs.steam.package
        else
          pkgs.steam;
      description = ''
        This must be the same you use for your system, or two instances will exist
                Default will try to pull steam from osConfig.programs.steam.package, else fallback to pkgs.steam'';
    };

    defaultPackages = mkOption {
      type = types.listOf types.package;
      default = (
        with pkgs;
        [
          gamemode
          mangohud
          winetricks
          gamescope
          libstrangle
        ]
        # WARNING: Remove once it's on stable channel.
        # Maybe overlay to move them to stable so we don't take unstable here.
        ++ [ pkgs-unstable.umu-launcher ]
      );

    };

    extraPkgs = mkOption {
      type = types.listOf types.package;
      default = [ ];

    };

    winePackages = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.wineWowPackages.stableFull ];
    };
    protonPackages = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.proton-ge-bin ];
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

    runners = mkOption { type = types.listOf (types.either types.package runnerType); };
  };
  config = mkIf cfg.enable {
    # Add custom lutris to the home packages.
    home.packages =
      let
        lutris-override = {
          # All this does is add their own non-overridable steam to extraPkgs.
          steamSupport = false;
          extraPkgs =
            pkgs: cfg.defaultPackages ++ cfg.extraPkgs ++ optional (cfg.steamPackage != null) cfg.steamPackage;
        };
      in
      [ (cfg.package.override lutris-override) ];
    # Link wine packages, for some reason it trips out if there's any caps on the name.
    # Couldn't find a better way than linking the wine package to local/share.
    xdg.dataFile =
      let
        mkWine = (
          type: packages:
          packages
          |> map (
            pkg:
            let
              name = toLower pkg.name;
            in
            (nameValuePair name {
              target = "lutris/runners/${type}/${name}";
              source = pkg;
            })
          )
        );
        proton-links = cfg.protonPackages |> map (pkg: pkg.steamcompattool) |> mkWine "proton";
        wine-links = cfg.winePackages |> mkWine "wine";
      in
      proton-links ++ wine-links |> listToAttrs;
    # Link other runners.
    xdg.configFile =
      let
        pkgToRunner = (
          runner-package: {
            name = runner-package.pname;
            package = runner-package;
            config.runner_executable = lib.getExe runner-package;
            system = cfg.runnersDefaultConfig.system;
          }
        );
        runnerToConfig = (
          runner-config:
          let
            name = runner-config.name;
            config = {
              ${name} = runner-config.config;
              inherit (runner-config) system;
            };
          in
          {
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
          runner
          |> (runner: if (types.package.check runner) then (pkgToRunner runner) else runner)
          |> runnerToConfig
        )
      ) { } cfg.runners;
  };
}
