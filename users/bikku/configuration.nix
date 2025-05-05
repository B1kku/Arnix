{
  pkgs,
  pkgs-unstable,
  inputs,
  flake-opts,
  ...
}:
{
  # This should take care of most game-related settings too.
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-gamemode ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };
  programs.gamemode.enable = true;
  programs.zsh.enable = true;

  users.users.bikku = {
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
    users.bikku = import ./home.nix;
  };
}
