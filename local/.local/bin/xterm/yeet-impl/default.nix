{ stdenv, xclip, ... }:

stdenv.mkDerivation {
  pname = "local bin xterm yeet-impl";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    xclip
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./yeet-impl $out/bin/

    runHook postInstall
  '';
}
