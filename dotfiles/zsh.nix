{
  config,
  pkgs,
  pkgs-unstable,
  flake-opts,
  ...
}:
let
  toZshPlugin = pkg: {
    name = pkg.pname;
    src = pkg.src;
  };
in
{
  programs.zsh = {
    enable = true;
    history = {
      ignoreAllDups = true;
      size = 1000;
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;
    plugins = [
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
    ] ++ (map toZshPlugin (with pkgs; [ zsh-syntax-highlighting ]));
    localVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#${config.colorscheme.palette.base0C}";
    };
    shellAliases = {
      list-colors = ''
        for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}''${(l:3::0:)i}%f " ''${''${(M)$((i%6)):#3}:+$'\n'}; done
      '';
    };
    initExtra =
      let
        min_days = "7";
        main_color = "069";
        days_color = "196";
        update_checker = ''
          LAST_UPDATE=$(date -r "${flake-opts.flake-dir + "/flake.lock"}" +%s)
          DAYS_SINCE_LAST_UPDATE=$((($(date +%s) - LAST_UPDATE) / 86400))
          if [ "$DAYS_SINCE_LAST_UPDATE" -ge ${min_days} ]; then
            print -Pn "%F{${main_color}}System hasn't been updated in %F{${days_color}}$LAST_UPDATE days%F{${main_color}}.\nConsider updating your flake.\n"
          fi
        '';
      in
      update_checker;
  };
}
