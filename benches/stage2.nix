{ stdenv, pkgs, bench-stage1 }:

stdenv.mkDerivation {
  name = "bench-stage2";
  src = bench-stage1;
  nativeBuildInputs = with pkgs; [ cmake ];
  cmakeDir = "../bench";
  enableParallelBuilding = true;
  installPhase = "cd .. && mkdir out && mv build out/bench && mkdir $out && cp -r * $out";
}
