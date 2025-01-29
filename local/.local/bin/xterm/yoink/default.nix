{ stdenv, xclip, ... }:

stdenv.mkDerivation {
  pname = "local bin xterm yoink";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    xclip
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./yoink $out/bin/

    runHook postInstall
  '';
}
