{ config, lib, pkgs, pkgs-unstable, inputs, home, ... }:

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
    # ../../dotfiles/lf.nix
    ../../dotfiles/games.nix
    # ../../dotfiles/directories.nix
  ];
  # Same case as enabling bash, let home manager add variables to it.
  xsession.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "/run/media/bikku/Data-SSD/Documents/";
    download = "/run/media/bikku/Data-HDD/Downloads/";
  };
  home.shellAliases = {
      arnix-rebuild = "sudo nixos-rebuild switch";
      arnix-update = "nix flake update /etc/nixos";
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
  };
  # programs.bash.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  # No sftpman integration yet on 23.11
  # programs.sftpman
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
  };
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
    deluge
  ];
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
