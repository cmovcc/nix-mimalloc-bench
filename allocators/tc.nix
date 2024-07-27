let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  name = "tc";
  src = fetchFromGitHub {
    owner = "gperftools";
    repo = "gperftools";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  nativeBuildInputs = with pkgs; [ autoconf automake libtool ];
  configurePhase = ''
    ./autogen.sh
    CXXFLAGS="$CXXFLAGS -w -DNDEBUG -O2" ./configure --enable-minimal --disable-debugalloc
  '';
  enableParallelBuilding = true;
  installPhase = "mkdir -p $out/.libs && cp .libs/libtcmalloc_minimal.so $out/.libs";
}
