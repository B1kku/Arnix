{ config, lib, pkgs, pkgs-unstable, inputs, home, ... }:

{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";

  # colorScheme = inputs.nix-colors.colorSchemes.stella;
  # colorScheme = inputs.nix-colors.colorSchemes.spaceduck;
  # colorScheme = inputs.nix-colors.colorSchemes.harmonic16-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.dracula;
  colorScheme = {
    name = "Duskfox";
    slug = "nightfox";
    author = "EdenEast";
    palette = {
      base00 = "232136";
      base01 = "2d2a45";
      base02 = "373354";
      base03 = "47407d";
      base04 = "6e6a86";
      base05 = "e0def4";
      base06 = "cdcbe0";
      base07 = "e2e0f7";
      base08 = "eb6f92";
      base09 = "ea9a97";
      base0A = "f6c177";
      base0B = "a3be8c";
      base0C = "9ccfd8";
      base0D = "569fba";
      base0E = "c4a7e7";
      base0F = "eb98c3";
    };
  };
  # Green and red a bit undistinguishable
  # Whatever zsh uses for autocomplete also a bit too dark
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../dotfiles/firefox.nix
    ../../dotfiles/neovim.nix
    ../../dotfiles/gnome.nix
    ../../dotfiles/alacritty.nix
    ../../dotfiles/sshfs.nix
    ../../dotfiles/games.nix
    ../../dotfiles/tmux.nix
    ../../dotfiles/yazi.nix
    ../../dotfiles/lazygit.nix
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
    deluge
    libnotify
    bedrock-mc
  ];
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
