{
  gamemode,
  proton-ge-bin,
  writeShellScript,
  ...
}:
proton-ge-bin.overrideAttrs (
  attrs:
  let
    wrapperScript = writeShellScript "proton" ''
      ${gamemode}/bin/gamemoderun REPLACEME/proton-unwrapped "$@"
    '';
  in
  {
    pname = "${attrs.pname}-gamemode";
    postBuild = ''
      mv $steamcompattool/proton $steamcompattool/proton-unwrapped
      cp ${wrapperScript} $steamcompattool/proton
      sed -i -r "s|REPLACEME|$steamcompattool|" $steamcompattool/proton
    '';
  }
)
