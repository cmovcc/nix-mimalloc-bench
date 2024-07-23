{
  description = "mimalloc-bench";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{self, nixpkgs, ...}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      test = pkgs.stdenv.mkDerivation {
        name = "test";
        installPhase = "touch $out";
      };
      version = "dirty";
      hm = pkgs.callPackage ./allocators/hm.nix { inherit version; };
    in
    {
      packages.${system} = {
        inherit hm;
      };
    };
}






