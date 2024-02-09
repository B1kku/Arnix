{ pkgs, lib, ... }:

{
  xdg.configFile.".lficons" = {
    source = ./lf/icons;
    target = "lf/icons";
  };

  programs.lf = {
    enable = true;
    settings = { icons = true; };
  };
}
