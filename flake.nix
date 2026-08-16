# Main flakes file for those programs I want that aren't available elsewhere.

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
    copilot-cli.url = "github:scarisey/copilot-cli-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    helium.inputs.nixpkgs.follows = "nixpkgs";
    copilot-cli.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      helium,
      copilot-cli,
      home-manager,
      plasma-manager,
      ...
    }:
    {

      nixosConfigurations."echolotl-nixo" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ helium.overlays.default ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [plasma-manager.homeModules.plasma-manager];
              users.echolotl = import ./home.nix; # Home Manager configuration actually lives in home.nix.
            };
            environment.systemPackages = [
              copilot-cli.packages.x86_64-linux.default
            ];
          }
        ];
      };

    };
}
