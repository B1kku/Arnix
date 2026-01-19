{ inputs }:
final: prev:
let
  system = final.stdenv.hostPlatform.system;
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
in

{

  lib = prev.lib // (import ../lib/lib.nix final prev);
  proton-gamemode = (import ./proton-gamemode-wrapper.nix prev);
  grub-yorha = prev.fetchFromGitHub {
    owner = "OliveThePuffin";
    repo = "yorha-grub-theme";
    rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
    sha256 = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
  };
  silent-sddm = prev.callPackage ./silentSDDM.nix { };
  ###==================== Flex taped Packages ====================###
  quickshell = inputs.quickshell.packages.${system}.default.withModules (
    with pkgs-unstable.kdePackages;
    [
      qt5compat
      qtmultimedia
      qtimageformats
    ]
  );

  wooz = prev.callPackage ./wooz.nix { };
}
