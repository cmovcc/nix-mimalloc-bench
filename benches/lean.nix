let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "lean";
  src = pkgs.fetchFromGitHub {
    owner = "leanprover-community";
    repo = "lean";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [ cmake gmp ];
  cmakeFlags = [
    "-DCUSTOM_ALLOCATORS=OFF"
    "-DLEAN_EXTRA_CXX_FLAGS=\"-w\""
    "-DCMAKE_INSTALL_LIBDIR=out/release"
  ];
  cmakeDir = "../src";
  enableParallelBuilding = true;
  installPhase = "cd .. && mkdir $out && cp -r * $out";
}
