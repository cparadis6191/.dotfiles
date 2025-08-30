{ python3, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./calc           $out/bin/
    install ./isotounix      $out/bin/
    install ./stopwatch      $out/bin/
    install ./unixtoiso      $out/bin/
    install ./unixtolocaliso $out/bin/
    install ./vim            $out/bin/
    install ./vrep           $out/bin/
    install ./yedit          $out/bin/

    runHook postInstall
  '';
}
