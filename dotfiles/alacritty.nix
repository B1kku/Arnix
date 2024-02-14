{ lib, pkgs, pkgs-unstable, ... }:
let terminal-font = "FiraCode Nerd Font";
in {

  home.packages = [
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      exec "${lib.getExe pkgs-unstable.alacritty}" -e "$@"
    '')
  ];
  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
    settings = {
      # shell.program = "${pkgs.zsh}/bin/zsh";
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
  };
}
