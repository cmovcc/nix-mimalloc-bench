{ stdenv, pkgs, lib, bench-stage2, benches }:

let
  objs_benches = builtins.map (name: builtins.getAttr name benches) (builtins.attrNames benches);
  build_phase = lib.strings.concatMapStrings (obj:
    "${obj.cmd1}"
  ) objs_benches;
in

stdenv.mkDerivation {
  name = "bench-stage3";
  src = bench-stage2;
  # add as dependencies benchmarks that are added to output during the build phase
  nativeBuildInputs =
    with pkgs; [ util-linux rsync ]
    ++
    (builtins.map (obj: obj.drv) objs_benches);
  buildPhase = build_phase;
  installPhase = "mkdir $out && cp -r * $out";
}
