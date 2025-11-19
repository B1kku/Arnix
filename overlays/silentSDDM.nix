{
  lib,
  stdenvNoCC,
  kdePackages,
  theme ? "default",
  theme-overrides ? { },
  extraBackgrounds ? [ ],
  fetchFromGitHub,
}:
let
  inherit (lib) licenses;
  inherit (lib)
    attrValues
    concatStringsSep
    map
    ;
  inherit (lib.generators) toINI;

  propagatedBuildInputs = attrValues {
    inherit (kdePackages) qtmultimedia qtsvg qtvirtualkeyboard;
  };

in
stdenvNoCC.mkDerivation (final: rec {
  inherit propagatedBuildInputs;

  pname = "silent";
  version = "1.3.5";
  src = fetchFromGitHub {
    owner = "uiriansan";
    repo = "SilentSDDM";
    rev = "v${version}";
    hash = "sha256-R0rvblJstTgwKxNqJQJaXN9fgksXFjPH5BYVMXdLsbU=";
  };

  dontWrapQtApps = true;

  installPhase =
    let
      basePath = "$out/share/sddm/themes/${final.pname}";
      overrides' = toINI { } theme-overrides;
      overrides = builtins.replaceStrings [ "=" ] [ " = " ] overrides';
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}

      substituteInPlace ${basePath}/metadata.desktop \
        --replace-warn configs/default.conf configs/${theme}.conf

      chmod +w ${basePath}/configs/${theme}.conf
      echo '${overrides}' >> ${basePath}/configs/${theme}.conf

      chmod -R +w ${basePath}/backgrounds
      ${concatStringsSep "\n" (map (bg: "cp ${bg} ${basePath}/backgrounds/${bg.name}") extraBackgrounds)}
    '';

  meta.licenses = licenses.gpl3;
})
