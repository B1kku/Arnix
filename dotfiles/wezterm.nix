{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  config-dir = "/dotfiles/wezterm/";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      exec "${lib.getExe config.programs.wezterm.package}" -e "$@"
    '')
  ];
  xdg.configFile = {
    "wezterm/wezterm.lua" = {
      # Without this, it won't reload automatically.
      # Technically only the main file needs this (if I ever expand).
      source = config.lib.extra.mkFlakePath "/dotfiles/wezterm/wezterm.lua";
    };
    "wezterm/util.lua" = {
      source = config.lib.extra.mkFlakePath "/dotfiles/wezterm/util.lua";
    };
    "wezterm/colors" = {
      source = config.lib.extra.mkFlakePath "/dotfiles/wezterm/colors";
    };

  };
  programs.wezterm = {
    enable = true;
    package = pkgs-unstable.wezterm;
  };
}
