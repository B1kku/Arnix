{ config, pkgs, lib, ... }
( final: prev: {
  neovim = prev.neovim.override {
    extraPkgs = pkgs: with pkgs; [
      fzf
    ];
  };
})
