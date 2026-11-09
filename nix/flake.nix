{
  description = "Tom's Mac: macOS settings and Homebrew packages via nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-darwin, ... }: {
    darwinConfigurations.tom-mbp = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin/system.nix
        ./darwin/homebrew.nix
      ];
    };
  };
}
