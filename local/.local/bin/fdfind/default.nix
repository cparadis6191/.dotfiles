{ fd, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin-fdfind";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    fd
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./fdfind $out/bin/

    runHook postInstall
  '';
}
