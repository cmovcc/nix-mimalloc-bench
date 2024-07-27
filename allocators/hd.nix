let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub, heap-layers }:

stdenv.mkDerivation rec {
  name = "hd";
  src = fetchFromGitHub {
    owner = "emeryberger";
    repo = "Hoard";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  configurePhase = ''
    sed -i 's|git clone https://github.com/emeryberger/Heap-Layers|echo "Heap-Layers: already fetched"|' src/Makefile
    cp -r ${heap-layers} src/Heap-Layers
    cd src
  '';
  installPhase = "mkdir -p $out/src/ && cp libhoard.so $out/src";
}
