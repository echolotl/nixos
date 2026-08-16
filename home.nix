{ ... }:

{
  imports = [
    ./plasma.nix
  ];
  home.username = "echolotl";
  home.homeDirectory = "/home/echolotl";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
