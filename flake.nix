{
  description = "A very basic flake";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        Arnix = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
        };
      };
      homeConfigurations = {
        Arnix = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            {
              home = {
                username = "bikku";
                homeDirectory = "/home/bikku";
                stateVersion = "23.11";
              };
            }
          ];
        };
      };
    };
}
