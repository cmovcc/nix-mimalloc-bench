{
  description = "mimalloc-bench";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    mimalloc-bench = {
      url = "github:daanx/mimalloc-bench";
      flake = false;
    };
  };

  outputs = inputs@{self, nixpkgs, mimalloc-bench}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # allocators
      ## TODO: dh
      ff = pkgs.callPackage ./allocators/ff.nix {};
      fg = pkgs.callPackage ./allocators/fg.nix {};
      gd = pkgs.callPackage ./allocators/gd.nix {};
      ## TODO: hd
      hm = pkgs.callPackage ./allocators/hm.nix {};
      hml = pkgs.callPackage ./allocators/hml.nix {};
      iso = pkgs.callPackage ./allocators/iso.nix {};
      je = pkgs.callPackage ./allocators/je.nix {};
      lf = pkgs.callPackage ./allocators/lf.nix {};
      ## TODO: lp
      lt = pkgs.callPackage ./allocators/lt.nix {};
      # benches
      ## stage 1: fetch mimalloc-bench repo + external resources
      bench-stage1 = pkgs.callPackage ./benches/stage1.nix {
        inherit mimalloc-bench;
      };

    in
    {
      packages.${system} = {
        inherit
          ff fg gd hm hml iso je lf lt
          bench-stage1;
      };
    };
}
