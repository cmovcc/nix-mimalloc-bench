let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub, heap-layers }:

clangStdenv.mkDerivation rec {
  name = "dh";
  src = fetchFromGitHub {
    owner = "emeryberger";
    repo = "DieHard";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  # mimalloc-bench alike
  configurePhase = ''
    rm -rf ./benchmarks/ ./src/archipelago/ ./src/build/ ./src/exterminator/ ./src/local/ ./src/original-diehard/ ./src/replicated/ ./docs
    sed -i 's|git clone https://github.com/emeryberger/Heap-Layers|echo "Heap-Layers: already fetched"|' src/Makefile
    cp -r ${heap-layers} src/Heap-Layers
  '';
  buildPhase = ''
    TARGET=libdieharder make -C src linux-gcc-64
  '';
  installPhase = "mkdir -p $out/src && cp src/libdieharder.so $out/src";
}
