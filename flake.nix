{
  description = "Personal NixOS config.";
  inputs = {
    nixpkgs-main.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-main";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-main";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-main";
    };
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs =
    {
      nixpkgs-main,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs-main {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ((import ./overlays/pkgs.nix) { inherit inputs system; }) ] ++ [ inputs.niri.overlays.niri ];
      };
      lib = pkgs.lib;
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      flake-opts = {
        # Some things just end up needing to know where the flake is.
        # Such as home manager for mkoutofstoresymlink or nvim for updating lazy.lock

        # Controls whether to link directly to the flake directory
        pure = false;
        flake-dir = "/etc/nixos";
        # Centralize flake inputs substituters and public keys
        # to pass to configs and tie them if the input is removed.
        extraCaches = lib.extra.getCachesFromInputs inputs {
          nix-gaming = {
            substituters = [ "https://nix-gaming.cachix.org" ];
            trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
          };
          niri = {
            substituters = [ "https://niri.cachix.org" ];
            trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
          };
        };
      };
    in
    {
      formatter.x86_64-linux = pkgs-unstable.nixfmt-rfc-style;
      nixosConfigurations = {
        Arnix = nixpkgs-main.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              lib
              flake-opts
              ;
          };
          modules = [
            ./hosts/Arnix/configuration.nix
            nixpkgs-main.nixosModules.readOnlyPkgs
            { nixpkgs.pkgs = pkgs; }
          ];
        };
      };
    };
}
