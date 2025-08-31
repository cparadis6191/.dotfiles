{ fzf, ripgrep, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin-note";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    fzf
    ripgrep
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./note  $out/bin/
    install ./notes $out/bin/
    install ./snote $out/bin/

    runHook postInstall
  '';
}
