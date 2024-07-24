let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  name = "je";
  src = fetchFromGitHub {
    owner = "jemalloc";
    repo = "jemalloc";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [ autoconf automake ];
  configurePhase = ''
    ./autogen.sh --enable-doc=no --enable-static=no --disable-stats
  '';
  enableParallelBuilding = true;
  installPhase = "mkdir -p $out/lib && cp lib/libjemalloc.so $out/lib";
}
