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
  wezterm = inputs.nixpkgs-old.legacyPackages.${system}.wezterm;
  gnomeExtensions = prev.gnomeExtensions // {
    valent =
      let
        version = "1.0.0.alpha.46";
      in
      prev.gnomeExtensions.valent.overrideAttrs (attrs: {
        src = prev.fetchFromGitHub {
          owner = "andyholmes";
          repo = "gnome-shell-extension-valent";
          rev = "v${version}";
          hash = "sha256-OY0fxO6IYg7xukYYuK0QM9YriaEAlM2dH6t8Wv3XKIs=";
        };
      });
  };
}
