{ eza, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local/.local/bin";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./binxxd         $out/bin/
    install ./calc           $out/bin/
    install ./cdb-impl       $out/bin/
    install ./cxxd           $out/bin/
    install ./hexxd          $out/bin/
    install ./isotounix      $out/bin/
    install ./journal        $out/bin/
    install ./journals       $out/bin/
    install ./la             $out/bin/
    install ./ll             $out/bin/
    install ./mkb            $out/bin/
    install ./post           $out/bin/
    install ./pre            $out/bin/
    install ./repeat         $out/bin/
    install ./stopwatch      $out/bin/
    install ./texxd          $out/bin/
    install ./unixtoiso      $out/bin/
    install ./unixtolocaliso $out/bin/
    install ./vim            $out/bin/
    install ./vrep           $out/bin/

    runHook postInstall
  '';
}
