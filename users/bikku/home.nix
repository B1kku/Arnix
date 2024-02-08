{ config, lib, pkgs, inputs, home, ... }:

{
  # TODO: Rsync + sshfs
  # TODO: TMux
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  imports = [
    ../../dotfiles/firefox.nix
    ../../dotfiles/neovim.nix
    ../../dotfiles/gnome.nix
    ../../dotfiles/alacritty.nix
    ../../dotfiles/sshfs.nix
    ../../dotfiles/lf.nix
    ../../dotfiles/games.nix
  ];
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      arnix-rebuild = "sudo nixos-rebuild switch";
      arnix-update = "nix flake update /etc/nixos";
    };
  };
  # programs.bash.enable = true;
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
    vesktop
    maven
    htop
    bitwarden
    neofetch
    peek
    fira-code-nerdfont
    prismlauncher
    qbittorrent
  ];
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
