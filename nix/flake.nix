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
      hostname = "${username}-work-macbook-pro";

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
          ./modules/homebrew
          ./modules/agents
          ./work-stuff.nix

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
          inherit
            inputs
            system
            username
            hostname
            ;
        };
      };
    in
    {
      darwinConfigurations = {
        "${hostname}" = work-macbook-config;
        default = work-macbook-config;
      };

      # Expose packages for development
      packages.aarch64-darwin = {
        inherit (nixpkgs.legacyPackages.${system}.extend overlay) jj-fzf;
      };
    };
}
