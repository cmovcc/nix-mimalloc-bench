let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub, pkgs }:

clangStdenv.mkDerivation rec {
  name = "scudo";
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    sparseCheckout = [ "compiler-rt/lib/scudo/standalone" ];
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };

  nativeBuildInputs = with pkgs; [ lld ];
  # seemingly no directory exploration tweak needed
  #configurePhase = "tree &> /dev/null";
  buildPhase = ''
    cd compiler-rt/lib/scudo/standalone
    # tweak wrt mimalloc-bench: -static-libstdc++ flag
    clang++ -flto -fuse-ld=lld -fPIC -std=c++14 -fno-exceptions $CXXFLAGS -fno-rtti -fvisibility=internal -msse4.2 -O3 -I include -shared -static-libstdc++ -o libscudo.so *.cpp -pthread
  '';
  enableParallelBuilding = true;
  installPhase = ''
    mkdir -p $out/compiler-rt/lib/scudo/standalone
    cp libscudo.so $out/compiler-rt/lib/scudo/standalone
  '';
}
