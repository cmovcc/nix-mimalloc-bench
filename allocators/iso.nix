let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub }:

clangStdenv.mkDerivation rec {
  name = "iso";
  src = fetchFromGitHub {
    owner = "struct";
    repo = "isoalloc";
    rev = versions.${name}.rev;
    sha256 = versions.${name}.sha256;
  };
  makeFlags = [ "library" ];
  installPhase = "mkdir -p $out/build && cp build/libisoalloc.so $out/build";
}
