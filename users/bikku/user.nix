{
  pkgs,
  pkgs-unstable,
  inputs,
  flake-opts,
  lib,
  ...
}@args:
let
  username = "bikku";
in
{
  imports =
    let
      user_args = args // {
        inherit username;
      };
      user-system-modules = map (module: import module user_args) [
        ./system/virt.nix
        ../../modules/sunshine.nix
      ];
      system-modules = [
        inputs.home-manager.nixosModules.home-manager
      ];
    in
    user-system-modules ++ system-modules;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  environment.systemPackages = with pkgs; [
    gparted
  ];
  services.flatpak.enable = true;
  # This should take care of most game-related settings too.
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-gamemode ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };
  boot.supportedFilesystems.exfat = true;
  programs.gamemode.enable = true;
  programs.zsh.enable = true;
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "potato";
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit pkgs-unstable inputs flake-opts;
    };
    users.${username} = {
      programs.home-manager.enable = true;
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ./home.nix
      ];
      # Don't change randomly, used for internals.
      home.stateVersion = "23.11";
    };
  };
}
