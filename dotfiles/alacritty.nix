{ lib, pkgs, ... }:
let terminal-font = "FiraCode Nerd Font";
in {
  programs.alacritty = {
    enable = true;

    settings = {
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
