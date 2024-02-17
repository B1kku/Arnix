{ config, ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = with config.colorScheme.palette; {
          activeBorderColor = [ "#${base0D}" "bold" ];
          inactiveBorderColor = [ "#${base03}" ];
          optionsTextColor = [ "#${base0D}" ];
          selectedLineBgColor = [ "#${base03}" ];
          cherryPickedCommitBgColor = [ "#${base03}" ];
          cherryPickedCommitFgColor = [ "#${base0D}" ];
          unstagedChangesColor = [ "#${base08}" ];
          defaultFgColor = [ "#${base05}" ];
          searchingActiveBorderColor = [ "#${base0A}" ];
        };
      };
    };
  };
}
