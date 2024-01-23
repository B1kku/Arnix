{ config, lib, pkgs, inputs, home, ... }:

{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  imports = [ 
    ../../dotfiles/firefox.nix 
    ../../dotfiles/neovim.nix 
    ../../dotfiles/gnome.nix
    ../../dotfiles/alacritty.nix
  ];
  programs.zsh.enable = true;
  programs.bash.enable = true;

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    htop
    bitwarden
    vesktop
    # rofi
    lf
    neofetch
    peek
    fira-code-nerdfont
    prismlauncher
  ];
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
