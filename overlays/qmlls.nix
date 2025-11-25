(
  { pkgs-unstable, prev }:
  let
    deps = (
      (with pkgs-unstable.kdePackages; [
        qt5compat
        qtmultimedia
        qtimageformats
      ])
      ++ (with pkgs-unstable; [
        qt6.qtbase
        qt6.qtdeclarative
        qt6.qtwayland
        qt6.qtsvg
        cli11
        wayland
        wayland-protocols
        libdrm
        libgbm
        breakpad
        jemalloc
        xorg.libxcb
        pam
        pipewire
      ])
      ++ [ pkgs-unstable.quickshell ]
    );
    inputsBash = deps |> map (e: "\"${e}\"") |> prev.lib.concatStringsSep " ";
  in
  prev.writeShellScriptBin "qmlls" ''
    INPUTS=(${inputsBash})
    matches=()
    for dir in "''\${INPUTS[@]}"; do
      found=$(find "$dir" -type d -name "qml" -print -quit)
      if [ "$found" != "" ]; then
        matches+=("$found")
      fi
    done
    args=""
    for match in "''\${matches[@]}"; do
      args="-I $match $args\\"
    done
    echo "$args"
    ${pkgs-unstable.kdePackages.qtdeclarative}/bin/qmlls \
    "$@" $args
  ''
)
