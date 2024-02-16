{ lib, pkgs, pkgs-unstable, ... }:
let
  TOMLgenerator = pkgs.formats.toml { };
  terminal-font = "FiraCode Nerd Font";
  config = {
    window = {
      decorations = "None";
      opacity = 0.75;
      startup_mode = "Maximized";
    };
    font = {
      normal.family = terminal-font;
      size = 12;
    };
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      exec "${lib.getExe pkgs-unstable.alacritty}" -e "$@"
    '')
  ];
  # This is needed because home manager, although it checks
  # pkg version, it's not doing it properly, which leads
  # to a yaml file and therefore alacritty complains nonstop.
  xdg.configFile = {
    "alacritty/alacritty.toml".source =
      TOMLgenerator.generate "alacritty.toml" config;
  };
  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
    # settings = { };
  };
}
