{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.sshfs ];
  home.shellAliases = { };
}
