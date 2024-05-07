{ config, lib, pkgs, pkgs-unstable, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      exec "${lib.getExe pkgs-unstable.alacritty}" -e "$@"
    '')
  ];
  xdg.configFile."wezterm" = {
    # Without this, it won't reload automatically.
    # Technically only the main file needs this (if I ever expand).
    recursive = true; 
    source = ./wezterm;
  };
  programs.wezterm.enable = true;
}
