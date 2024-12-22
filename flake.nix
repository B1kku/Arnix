{
  description = "Personal NixOS config.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.12";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.12";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming = {
      url = "github:fufexan/nix-gaming/fce565402d5b1ed4e92c4a9dfcd094d0172d8f0b";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (import ./overlays/pkgs.nix) ];
      };
      lib = pkgs.lib;
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      formatter.x86_64-linux = pkgs-unstable.nixfmt-rfc-style;
      nixosConfigurations = {
        Arnix = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs
              pkgs-unstable
              lib
              home-manager
              ;
          };
          modules = [ ./hosts/Arnix/configuration.nix ];
        };
      };
    };
}
