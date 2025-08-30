{ stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin-text-proc";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./post   $out/bin/
    install ./pre    $out/bin/
    install ./repeat $out/bin/

    runHook postInstall
  '';
}
