{ fzf, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin-bookmark";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    fzf
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./cdb-impl $out/bin/
    install ./mkb      $out/bin/

    runHook postInstall
  '';
}
