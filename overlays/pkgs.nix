{ inputs, system }:
final: prev: {
  lib = prev.lib // (import ../lib/lib.nix final prev);
  protonhax =
    let
      protonhax_script = prev.fetchFromGitHub {
        owner = "jcnils";
        repo = "protonhax";
        rev = "1.0.5";
        hash = "sha256-5G4MCWuaF/adSc9kpW/4oDWFFRpviTKMXYAuT2sFf9w=";
      };
    in
    prev.writeShellApplication {
      name = "protonhax";
      runtimeInputs = [ prev.steam-run ];
      text = ''steam-run ${protonhax_script}/protonhax "$@"'';
    };
  proton-gamemode = (import ./proton-gamemode-wrapper.nix prev);

  ###==================== Flex taped Packages ====================###
  gnomeExtensions = prev.gnomeExtensions // {
    ### Reason: KDE Connect updated the protocol, pkgs-unstable isn't updating for some reason.
    gsconnect = prev.gnomeExtensions.gsconnect.overrideAttrs (attrs: {
      src =
        let
          version = "66";
        in
        prev.fetchFromGitHub {
          owner = "GSConnect";
          repo = "gnome-shell-extension-gsconnect";
          rev = "v${version}";
          hash = "sha256-QPvdSmt4aUkPvaOUonovrCxW4pxrgoopXGi3KSukVD8=";
        };
    });
  };
  grub-yorha = prev.fetchFromGitHub {
    owner = "OliveThePuffin";
    repo = "yorha-grub-theme";
    rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
    sha256 = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
  };
}
