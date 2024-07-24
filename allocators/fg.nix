let
  versions = builtins.fromJSON (builtins.readFile ../versions.json);
in

{ clangStdenv, fetchFromGitHub }:

clangStdenv.mkDerivation rec {
  name = "fg";
  src = fetchFromGitHub {
    owner = "UTSASRG";
    repo = "FreeGuard";
    rev = versions.${name}.commit;
    sha256 = versions.${name}.sha256;
  };
  makeFlags = [ "SSE2RNG=1" ];
  installPhase = "mkdir $out && cp libfreeguard.so $out";
}
