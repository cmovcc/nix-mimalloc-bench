let
  bench-sh6bench = builtins.fetchTarball {
   url = "http://www.microquill.com/smartheap/shbench/bench.zip";
   sha256 = "sha256:0pdf01d7mdg7mf1pxw3dcizfm7s93b9df8sjq6pzmrfl3dcwjq33";
  };
  bench-sh8bench = builtins.fetchTarball {
    url = "http://www.microquill.com/smartheap/SH8BENCH.zip";
    sha256 = "sha256:0w4djm17bw5hn7bx09398pkv1gzknlsxvi6xxjn44qnklc2r47ci";
  };
  bench-largepdf = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/geekaaron/Resources/master/resources/Writing_a_Simple_Operating_System--from_Scratch.pdf";
    sha256 = "sha256:04pddvdhy4x2fh9jjq9rwl52r8svcam7izg48z64kh75x611hm29";
  };
in

{ stdenv, lib, pkgs, mimalloc-bench }:

stdenv.mkDerivation {
  name = "bench-stage1";
  src = lib.sourceByRegex mimalloc-bench [
    "bench(/.*)?"
    "doc(/.*)?"
    "bench.sh"
    "build-bench-env.sh"
  ];
  nativeBuildInputs = with pkgs; [ dos2unix patch ];

  buildPhase = ''
    # sh6bench + sh8bench
    pushd bench/shbench
    cp ${bench-sh6bench} sh6bench.c
    dos2unix sh6bench.patch
    dos2unix sh6bench.c
    patch -p1 -o sh6bench-new.c sh6bench.c sh6bench.patch
    cp ${bench-sh8bench} sh8bench.c
    dos2unix sh8bench.patch
    dos2unix sh8bench.c
    patch -p1 -o sh8bench-new.c sh8bench.c sh8bench.patch
    popd

    # large pdf file
    mkdir extern
    cp ${bench-largepdf} extern/large.pdf
  '';
  installPhase = "mkdir $out && cp -r * $out";
}
