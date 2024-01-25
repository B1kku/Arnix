{ lib, pkgs, ... }:
let terminal-font = "FiraCode Nerd Font";
in {

  home.packages = [
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      exec "${lib.getExe pkgs.alacritty}" -e "$@"
    '')
  ];
  programs.alacritty = {
    enable = true;
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
