{ config, osConfig, lib, pkgs, pkgs-unstable, inputs, ... }:

{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  imports = [
    ../../dotfiles/colors.nix
    ../../dotfiles/games.nix
    ../../dotfiles/tmux.nix
    ../../dotfiles/yazi.nix
    ../../dotfiles/lazygit.nix
    ../../dotfiles/sshfs.nix
    ../../dotfiles/vesktop.nix
    ../../dotfiles/alacritty.nix
    ../../dotfiles/firefox.nix
    ../../dotfiles/neovim.nix
    ../../dotfiles/gnome.nix
    ./dirs.nix
  ];
  # Same case as enabling bash, let home manager add variables to it.
  xsession.enable = true;
  home.shellAliases = {
    arnix-rebuild = "sudo nixos-rebuild switch";
    arnix-update = "nix flake update /etc/nixos";
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    localVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE =
        "fg=#${config.colorscheme.palette.base0C}";
    };
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  # No sftpman integration yet on 23.11
  # programs.sftpman
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    mlocate
    rsync
    maven
    htop
    bitwarden
    neofetch
    peek
    fira-code-nerdfont
    prismlauncher
    deluge
    libnotify
    cage
  ];
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
