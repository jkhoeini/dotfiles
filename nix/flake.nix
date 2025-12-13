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
      host = "work_macbook";

      overlay = final: prev: {
        jj-fzf = final.callPackage ./pkgs/jj-fzf { };
        kanata = final.callPackage ./pkgs/kanata { };
      };

      home-manager-configs.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        # user specific config
        users.${username} = import ./home/${username}.nix;

        extraSpecialArgs = {
          inherit username inputs;
        };
      };

      work-macbook-config = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          # nix-darwin modules
          ./modules/programs
          ./modules/services
          ./hosts/${host}/configuration.nix

          # home-manager modules
          home-manager.darwinModules.home-manager
          home-manager-configs
          ./modules/files

          # overlays
          ({ ... }: { nixpkgs.overlays = [ overlay ]; })
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
