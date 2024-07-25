let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  name = "tbb";
  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [ cmake ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DTBB_BUILD=OFF"
    "-DTBB_TEST=OFF"
    "-DTBB_OUTPUT_DIR_BASE=bench"
    # otherwise, reproducibility issue leads to nix build failure, even on master
    # TODO: upstream fix?
    # https://discourse.nixos.org/t/rpath-of-binary-contains-a-forbidden-reference-to-build/12200
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];
  installPhase = "mkdir $out && cp -r bench_release $out";
}
