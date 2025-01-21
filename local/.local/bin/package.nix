{ stdenv, ... }:

stdenv.mkDerivation {
  pname = "local/.local/bin";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    cp ./binxxd         $out/bin/
    cp ./calc           $out/bin/
    cp ./cdb-impl       $out/bin/
    cp ./cxxd           $out/bin/
    cp ./hexxd          $out/bin/
    cp ./isotounix      $out/bin/
    cp ./journal        $out/bin/
    cp ./journals       $out/bin/
    cp ./la             $out/bin/
    cp ./ll             $out/bin/
    cp ./mkb            $out/bin/
    cp ./post           $out/bin/
    cp ./pre            $out/bin/
    cp ./repeat         $out/bin/
    cp ./stopwatch      $out/bin/
    cp ./texxd          $out/bin/
    cp ./unixtoiso      $out/bin/
    cp ./unixtolocaliso $out/bin/
    cp ./vim            $out/bin/
    cp ./vrep           $out/bin/

    runHook postInstall
  '';
}
