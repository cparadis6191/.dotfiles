{ eza, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local bin ls";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    eza
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./la $out/bin/
    install ./ll $out/bin/

    runHook postInstall
  '';
}
