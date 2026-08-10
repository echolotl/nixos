# Main flakes file for those programs I want

{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        helium.url = "github:schembriaiden/helium-browser-nix-flake";
        copilot-cli.url = "github:scarisey/copilot-cli-flake";
        helium.inputs.nixpkgs.follows = "nixpkgs";
        copilot-cli.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, helium, copilot-cli, ...}: {

        nixosConfigurations."echolotl-nixo" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
            ./configuration.nix
            {
            nixpkgs.overlays = [ helium.overlays.default ];
            environment.systemPackages = [
                copilot-cli.packages.x86_64-linux.default
                ];
            }
            ];
        };

    };
}
