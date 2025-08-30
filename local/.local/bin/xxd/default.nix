{ stdenv, xxd, ... }:

stdenv.mkDerivation {
  pname = "local-bin-xxd";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    xxd
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./binxxd $out/bin/
    install ./cxxd   $out/bin/
    install ./hexxd  $out/bin/
    install ./texxd  $out/bin/

    runHook postInstall
  '';
}
