{ config, lib, pkgs, pkgs-unstable, inputs, home, ... }:

{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";

  # colorScheme = inputs.nix-colors.colorSchemes.stella;
  # colorScheme = inputs.nix-colors.colorSchemes.spaceduck;
  # colorScheme = inputs.nix-colors.colorSchemes.harmonic16-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.dracula;
  # colorScheme = inputs.nix-colors.colorSchemes.solarized-dark;
  colorScheme = {
    name = "DoomOne";
    slug = "doom";
    author = "Unkown";
    palette = {
      base00 = "282c34";
      base01 = "4db5bd";
      base02 = "ecbe7b";
      base03 = "5b6268";
      base04 = "2257a0";
      base05 = "abb2bf";
      base06 = "a9a1e1";
      base07 = "dfdfdf";
      base08 = "ff6c6b";
      base09 = "da8548";
      base0A = "da8548";
      base0B = "98be65";
      base0C = "5699af";
      base0D = "51afef";
      base0E = "c678dd";
      base0F = "46d9ff";
    };
  };
  # colorScheme = {
  #   name = "Duskfox";
  #   slug = "nightfox";
  #   author = "EdenEast";
  #   palette = {
  #     base00 = "232136";
  #     base01 = "2d2a45";
  #     base02 = "373354";
  #     base03 = "47407d";
  #     base04 = "6e6a86";
  #     base05 = "e0def4";
  #     base06 = "cdcbe0";
  #     base07 = "e2e0f7";
  #     base08 = "eb6f92";
  #     base09 = "ea9a97";
  #     base0A = "f6c177";
  #     base0B = "a3be8c";
  #     base0C = "9ccfd8";
  #     base0D = "569fba";
  #     base0E = "c4a7e7";
  #     base0F = "eb98c3";
  #   };
  # };
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
