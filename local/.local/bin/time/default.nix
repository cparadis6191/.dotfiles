{ python3, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin-time";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./isotounix      $out/bin/
    install ./unixtoiso      $out/bin/
    install ./unixtolocaliso $out/bin/

    runHook postInstall
  '';
}
