{ pkgs, pkgs-unstable, config, ... }:
{
  home.shellAliases = {
    lf = "yazi";
  };
  home.packages = [
    (pkgs.ouch.override {enableUnfree = true;})
  ];
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    plugins = with pkgs.yaziPlugins; {
      ouch = ouch;
    };
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        sort_by = "alphabetical";
        sort_dir_first = true;
      };
    };
  };
}
