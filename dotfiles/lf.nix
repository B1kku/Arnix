{ pkgs, lib, ... }:

{
  home.file.".lficons" = {
    source = ./lf/icons;
    target = ".config/lf/icons";
  };

  programs.lf = {
    enable = true;
    settings = { icons = true; };
  };
}
