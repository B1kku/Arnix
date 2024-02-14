{ config, lib, pkgs, pkgs-unstable, ... }:
{
  programs.tmux = {
    enable = true;
  };
}
