{ config, pkgs, ... }:

{
  home.username = "bikku";
  home.homeDirectory = "home/bikku";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [ htop neovim ];
}
