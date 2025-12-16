{
  description = "MSK's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "mohammadk";

      overlay = final: prev: {
        jj-fzf = final.callPackage ./pkgs/jj-fzf { };
        kanata = final.callPackage ./pkgs/kanata { };
      };

      work-macbook-config = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          # nix-darwin modules
          ./modules/programs
          ./modules/services
          ./modules/system-config

          # home-manager modules
          home-manager.darwinModules.home-manager
          ./modules/home
          ./modules/files

          # overlays
          (
            { ... }:
            {
              nixpkgs.overlays = [ overlay ];
            }
          )
        ];

        specialArgs = {
          inherit inputs system username;
        };
      };
    in
    {
      darwinConfigurations = {
        work_macbook = work-macbook-config;
        default = work-macbook-config;
      };
    };
}
