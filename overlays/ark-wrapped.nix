{
  ark,
  extraTools ? [ ],
  makeWrapper,
  symlinkJoin,
  lib,
}:
let
  inherit (lib) makeBinPath;
in
symlinkJoin {
  name = "ark-wrapped";
  paths = [ ark ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/ark \
    --prefix-each PATH : ${makeBinPath extraTools}
  '';
}
