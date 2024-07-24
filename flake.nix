{
  description = "mimalloc-bench";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    mimalloc-bench = {
      url = "github:daanx/mimalloc-bench";
      flake = false;
    };
  };

  # Various possible improvements:
  # - enableParallelBuilding = true seems to not be the default
  # - add toggle to try to compile benchmarks using bleeding edge toolchains
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
      ## TODO: mesh, mi, mi2, mng, nomesh, pa, rp, sc, st (!), scudo, sg, sm, sn, tbb, tc, tcg

      # benches
      lean = pkgs.callPackage ./benches/lean.nix {};
      redis = pkgs.callPackage ./benches/redis.nix {};
      rocksdb = pkgs.callPackage ./benches/rocksdb.nix {};

      # benches wrappers
      ## stage 1: fetch mimalloc-bench repo + external resources
      ### TODO: add lua
      bench-stage1 = pkgs.callPackage ./benches/stage1.nix {
        inherit mimalloc-bench;
      };
      ## stage 2: build basic benches and add output to previous stage
      bench-stage2 = pkgs.callPackage ./benches/stage2.nix {
        inherit mimalloc-bench bench-stage1;
      };

    in
    {
      packages.${system} = {
        inherit
          ff fg gd hm hml iso je lf lt
          lean redis rocksdb
          bench-stage1
          bench-stage2;
      };
    };
}
