{ pkgs-unstable, config, ... }: {
  home.shellAliases = { lf = "yazi"; };
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    settings = {
      manager = {
        sort_by = "alphabetical";
        sort_dir_first = true;
      };
    };
  };
}

