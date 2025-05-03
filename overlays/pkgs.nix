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

  ### Date: ?? feb? 25
  ### Reason: Ugly window border and drawing on new version.
  ### https://github.com/wezterm/wezterm/issues/6578
  wezterm = inputs.nixpkgs-wezterm.legacyPackages.${system}.wezterm;
  gnomeExtensions = prev.gnomeExtensions // {
    ### Reason: KDE Connect updated the protocol, pkgs-unstable isn't updating for some reason.
    gsconnect = prev.gnomeExtensions.gsconnect.overrideAttrs (attrs: {
      src =
        let
          version = "62";
        in
        prev.fetchFromGitHub {
          owner = "GSConnect";
          repo = "gnome-shell-extension-gsconnect";
          rev = "v${version}";
          hash = "sha256-HFm04XC61AjkJSt4YBc4dO9v563w+LsYDSaZckPYE14=";
        };
    });
  };
}
