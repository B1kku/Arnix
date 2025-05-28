{
  config,
  osConfig,
  lib,
  pkgs,
  pkgs-unstable,
  flake-opts,
  inputs,
  ...
}:
let
  # Little wrapper around nix shell, shorthand and allows specifying a branch.
  nix-shell-wrapper = pkgs.writeShellScriptBin "pkgs" ''
    export IN_NIX_SHELL="impure"
    nixpkgs="nixpkgs''${2:+"/nixos-$2"}"
    NIXPKGS_ALLOW_UNFREE=1 nix shell "$nixpkgs#$1" --impure
  '';
  flake-dir = flake-opts.flake-dir;
in
{
  programs.home-manager.enable = true;
  home.username = "bikku";
  home.homeDirectory = "/home/bikku";
  imports = [
    ../../dotfiles/colors.nix
    ../../dotfiles/games.nix
    ../../dotfiles/yazi.nix
    ../../dotfiles/lazygit.nix
    ../../dotfiles/vesktop.nix
    ../../dotfiles/zsh.nix
    ../../dotfiles/wezterm.nix
    ../../dotfiles/firefox.nix
    ../../dotfiles/neovim.nix
    ../../dotfiles/gnome.nix
    ./dirs.nix
    # ../../dotfiles/alacritty.nix
  ];
  lib = {
    extra = {
      mkFlakePath =
        if flake-opts.pure then
          (path: inputs.self + path)
        else
          (path: config.lib.file.mkOutOfStoreSymlink (flake-opts.flake-dir + path));
    };
  };
  # Same case as enabling bash, let home manager add variables to it.
  xsession.enable = true;

  home.shellAliases =
    let
      sudoWrap = (_: command: "pkexec ${command}");
      nixos-aliases =
        (
          {
            rebuild = "nh os switch ${flake-dir} -R | tee ${flake-dir + "/rebuild.log"}";
            update = "nh os switch ${flake-dir} -u -R | tee ${flake-dir + "/update.log"}";
            clean = "nh clean all --keep-since 7d --keep 5 --ask";
          }
          |> builtins.mapAttrs sudoWrap
        )
        // {
          repl = "nix repl -f '<nixpkgs>' --impure";
        };
    in
    {
      neofetch = "fastfetch";
    }
    // nixos-aliases;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    stdlib = builtins.readFile ../../dotfiles/direnvrc;
  };
  fonts.fontconfig.enable = true;
  home.packages =
    (with pkgs; [
      mlocate
      rsync
      rclone
      btop-rocm
      bitwarden
      fastfetch
      nerd-fonts.fira-code # TODO: Move to a proper setting.
      prismlauncher
      qbittorrent
      libnotify
      gthumb # Image viewer
      vlc
      nh
    ])
    # Gnome packages mainly
    # TODO: Move these to gnome.nix?
    ++ (with pkgs; [
      baobab # Disk space info
      nautilus # File browser
      gnome-clocks # Alarms
      gnome-weather # Weather applet
      gnome-music
      gnome-calculator
      gnome-system-monitor
      gnome-tweaks
      gnome-calendar
    ])
    ++ [ nix-shell-wrapper ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
  };
  # Don't change randomly, used for internals.
  home.stateVersion = "23.11";
}
