let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lf";
  src = fetchFromGitHub {
    owner = "Begun";
    repo = "lockfree-malloc";
    rev = versions.${name}.commit;
    sha256 = versions.${name}.sha256;
  };
  buildFlags = [ "liblite-malloc-shared.so" ];
  installPhase = "mkdir $out && cp liblite-malloc-shared.so $out";
}
