{ lib, pkgs, pkgs-unstable, config, ... }:
let
  TOMLgenerator = pkgs.formats.toml { };
  terminal-font = "FiraCode Nerd Font";
  alacritty-config = {
    window = {
      decorations = "None";
      opacity = 1;
      startup_mode = "Maximized";
    };
    font = {
      normal.family = terminal-font;
      size = 12;
    };
    colors = with config.colorScheme.palette; {
      primary = {
        background = "0x${base00}";
        foreground = "0x${base05}";
      };
      cursor = {
        text = "0x${base00}";
        cursor = "0x${base05}";
      };
      normal = {
        black = "0x${base00}";
        red = "0x${base08}";
        green = "0x${base0B}";
        yellow = "0x${base0A}";
        blue = "0x${base0D}";
        magenta = "0x${base0E}";
        cyan = "0x${base0C}";
        white = "0x${base05}";
      };
      bright = {
        black = "0x${base03}";
        red = "0x${base09}";
        green = "0x${base01}";
        yellow = "0x${base02}";
        blue = "0x${base04}";
        magenta = "0x${base06}";
        cyan = "0x${base0F}";
        white = "0x${base07}";
      };
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
      TOMLgenerator.generate "alacritty.toml" alacritty-config;
  };
  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
    # settings = { };
  };
}
