{
  description = "Nix dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake/97876f35dcd5";
    #niri.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    nixpkgs,
    home-manager,
    niri,
    ...
  }: let
    # system = "aarch64-linux"; If you are running on ARM powered computer
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      richard = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          #./niri.nix
          niri.homeModules.niri
        ];
      };
    };
  };
}
