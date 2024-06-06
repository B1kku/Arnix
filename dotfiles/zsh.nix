{ config, pkgs, pkgs-unstable, ... }:
let
  toZshPlugin = pkg: {
    name = pkg.pname;
    src = pkg.src;
  };
in {
  programs.zsh = {
    enable = true;
    history = {
      ignoreAllDups = true;
      size = 1000;
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;
    plugins = with pkgs; map toZshPlugin [ zsh-syntax-highlighting ];
    localVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE =
        "fg=#${config.colorscheme.palette.base0C}";
    };
  };
}
