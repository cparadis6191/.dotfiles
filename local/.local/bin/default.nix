{ fd, python3, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local bin";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    fd
    python3
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./calc           $out/bin/
    install ./cdb-impl       $out/bin/
    install ./fdfind         $out/bin/
    install ./isotounix      $out/bin/
    install ./journal        $out/bin/
    install ./journals       $out/bin/
    install ./mkb            $out/bin/
    install ./note           $out/bin/
    install ./notes          $out/bin/
    install ./post           $out/bin/
    install ./pre            $out/bin/
    install ./repeat         $out/bin/
    install ./snote          $out/bin/
    install ./stopwatch      $out/bin/
    install ./unixtoiso      $out/bin/
    install ./unixtolocaliso $out/bin/
    install ./vim            $out/bin/
    install ./vrep           $out/bin/
    install ./yedit          $out/bin/

    runHook postInstall
  '';
}
