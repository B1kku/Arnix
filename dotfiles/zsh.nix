{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
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
    plugins =
      [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./p10k;
          file = "p10k.zsh";
        }
      ]
      ++ (map toZshPlugin (with pkgs; [zsh-syntax-highlighting]));
    localVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#${config.colorscheme.palette.base0C}";
    };
  };
}
