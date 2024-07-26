let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub, pkgs }:

clangStdenv.mkDerivation rec {
  name = "lp";
  src = fetchFromGitHub {
    owner = "WebKit";
    repo = "WebKit";
    sparseCheckout = [ "Source/bmalloc/libpas" ];
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };

  nativeBuildInputs = with pkgs; [ cmake tree ];
  # TODO: FIXME horrible hack, I guess this forces directory exploration
  configurePhase = "tree &> /dev/null";
  buildPhase = ''
    cd Source/bmalloc/libpas
    # not required anymore
    #sed -i $ORIG '/Werror/d' CMakeLists.txt
    # still required
    sed -i $ORIG 's/extra_cmake_options=""/extra_cmake_options="-D_GNU_SOURCE=1"/' build.sh
    # do not build tests
    sed -i $ORIG 's/cmake --build $build_dir --parallel/cmake --build $build_dir --target pas_lib --parallel/' build.sh
    CC=clang CXX=clang++ LDFLAGS='-lpthread -latomic -pthread' bash ./build.sh -s cmake -v default -t pas_lib
  '';
  enableParallelBuilding = true;
  installPhase = ''
    mkdir -p $out/Source/bmalloc/libpas/build-cmake-default/Release
    cp build-cmake-default/Release/libpas_lib.so \
      $out/Source/bmalloc/libpas/build-cmake-default/Release
  '';
}
