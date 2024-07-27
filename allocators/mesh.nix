let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub, pkgs, heap-layers, gtest, mesh ? true}:

stdenv.mkDerivation rec {
  name = if mesh then "mesh" else "nomesh";
  src = fetchFromGitHub {
    owner = "plasma-umass";
    repo = "Mesh";
    rev = versions."mesh".rev;
    sha256 = versions."mesh".sha256;
  };

  patches = [
    ../patches/mesh-0001-gtest-heap-layers-skip-download.patch
  ];
  configurePhase = ''
    cp -r ${gtest} googletest-src
    cp -r ${heap-layers} heap_layers-src
  '';
  nativeBuildInputs = with pkgs; [ cmake ];
  buildPhase = ''
    cmake . ${if mesh then "" else "-DDISABLE_MESHING=ON"}
    make
  '';
  installPhase = ''
    mkdir -p $out/build/lib/
    cp build/lib/libmesh.so $out/build/lib
  '';
}
