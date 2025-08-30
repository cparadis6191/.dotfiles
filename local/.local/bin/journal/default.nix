{ stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin-journal";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./journal  $out/bin/
    install ./journals $out/bin/

    runHook postInstall
  '';
}
