{ stdenv, pkgs, lib, bench-stage3, allocs }:

let
  objs_allocs = builtins.map (name: builtins.getAttr name allocs) (builtins.attrNames allocs);
  conf_phase = lib.strings.concatMapStrings (obj:
    "cp -r ${obj.drv} extern/${obj.drv.name}\n"
  ) objs_allocs;
  build_phase = lib.strings.concatMapStrings (obj:
    "${obj.fix}"
  ) objs_allocs;
in

stdenv.mkDerivation {
  name = "bench-stage4";
  src = bench-stage3;
  # add as dependencies allocators that are added to output during the build phase
  nativeBuildInputs =
    [ pkgs.util-linux ]
    ++
    (builtins.map (obj: obj.drv) objs_allocs);
  configurePhase = conf_phase;
  buildPhase = build_phase;
  installPhase = "mkdir $out && cp -r * $out";
}
