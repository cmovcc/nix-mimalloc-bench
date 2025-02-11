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
  # - file upstream issue + PR: remove version in redis and rocksdb paths
  # - allocators:
  #   - LeanGuard, GuaNary article (building on top of SlimGuard)
  outputs = inputs@{self, nixpkgs, mimalloc-bench}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;

      # Librairies
      heap-layers = pkgs.callPackage ./libraries/heap-layers.nix {};
      gtest = pkgs.callPackage ./libraries/gtest.nix {};

      # Allocators
      dh = pkgs.callPackage ./allocators/dh.nix {
        inherit heap-layers;
      };
      ff = pkgs.callPackage ./allocators/ff.nix {};
      fg = pkgs.callPackage ./allocators/fg.nix {};
      gd = pkgs.callPackage ./allocators/gd.nix {};
      hd = pkgs.callPackage ./allocators/hd.nix {
        inherit heap-layers;
      };
      hm = pkgs.callPackage ./allocators/hm.nix {};
      # TODO: refactor
      hml = pkgs.callPackage ./allocators/hml.nix {};
      iso = pkgs.callPackage ./allocators/iso.nix {};
      je = pkgs.callPackage ./allocators/je.nix {};
      lf = pkgs.callPackage ./allocators/lf.nix {};
      lp = pkgs.callPackage ./allocators/lp.nix {};
      lt = pkgs.callPackage ./allocators/lt.nix {};
      mesh = pkgs.callPackage ./allocators/mesh.nix {
        inherit heap-layers gtest;
      };
      ## TODO: mi, mi2
      mng = pkgs.callPackage ./allocators/mng.nix {};
      nomesh = pkgs.callPackage ./allocators/mesh.nix {
        inherit heap-layers gtest;
        mesh = false;
      };
      ## TODO: pa: complex build process
      rp = pkgs.callPackage ./allocators/rp.nix {};
      sc = pkgs.callPackage ./allocators/sc.nix {};
      scudo = pkgs.callPackage ./allocators/scudo.nix {};
      ## TODO: st (!), make repo public before
      sg = pkgs.callPackage ./allocators/sg.nix {};
      sm = pkgs.callPackage ./allocators/sm.nix {};
      sn = pkgs.callPackage ./allocators/sn.nix {};
      sn-sec = pkgs.callPackage ./allocators/sn.nix {
        hardened = true;
      };
      tbb = pkgs.callPackage ./allocators/tbb.nix {};
      tc = pkgs.callPackage ./allocators/tc.nix {};
      ## TODO: tcg, bazel

      # Benches
      lean = pkgs.callPackage ./benches/lean.nix {};
      redis = pkgs.callPackage ./benches/redis.nix {};
      rocksdb = pkgs.callPackage ./benches/rocksdb.nix {};

      # Benches wrappers
      ## Stage 1: fetch mimalloc-bench repo + external resources
      bench-stage1 = pkgs.callPackage ./benches/stage1.nix {
        inherit mimalloc-bench;
      };
      ## Stage 2: build basic benches and add output to previous stage
      bench-stage2 = pkgs.callPackage ./benches/stage2.nix {
        inherit bench-stage1;
      };
      ## Stage 3: build other benches and add output to previous stage
      bench-stage3 = pkgs.callPackage ./benches/stage3.nix {
        inherit bench-stage2 benches;
      };
      ## Stage 4: build allocators and add output to previous stage
      bench-stage4 = pkgs.callPackage ./benches/stage4.nix {
        inherit bench-stage3 allocs;
      };
      ## Run: run built benchmarks (alla allt)
      run = pkgs.callPackage ./benches/run.nix {
        inherit bench-stage4 allocs benches;
      };

      # cmd1 = executed to build bench-stage3
      # cmd2 = fix when running benchmarks
      benches = {
        redis = { drv = redis; benches = "redis"; cmd2 = "";
          cmd1 = ''
            cp -r ${redis} extern/redis
          '';
        };
        lean = { drv = lean; benches = "lean lean-mathlib";
          # exclude out/release to avoid cmake issues during benchmark
          # as cmake cache does not support to be moved
          cmd1 = ''
            rsync -av ${lean}/ extern/lean --exclude=out/release/*
            mkdir extern/mathlib
            cp -u extern/lean/leanpkg/leanpkg.toml extern/mathlib
          '';
          # workaround around cmake issue
          cmd2 = ''
            mkdir -p extern/lean/out/release
            pushd extern/lean/out/release
            cmake ../../src -DCUSTOM_ALLOCATORS=OFF -DLEAN_EXTRA_CXX_FLAGS="-w"
            popd
          '';
        };
        rocksdb = { drv = rocksdb; benches = "rocksdb"; cmd2 = "";
          cmd1 = ''
            cp -r ${rocksdb} extern/rocksdb
          '';
        };
      };

      allocs = {
        hm = { drv = hm; fix = ""; };
        hml = { drv = hml;
          fix = "sed -i 's/hm\\/out-light\\/libhardened_malloc-light/hml\\/out-light\\/libhardened_malloc-light/' bench.sh\n";
        };
      };

    in
    {
      packages.${system} = {
        inherit
          heap-layers
          dh ff fg gd hd hm hml iso je lf lp lt mesh mng nomesh rp sc scudo sg sm sn sn-sec tbb tc
          lean redis rocksdb
          bench-stage1
          bench-stage2
          bench-stage3
          bench-stage4
          run;
      };
    };
}
