{ stdenv, local_bin_win32yank, ... }:

stdenv.mkDerivation {
  pname = "local/.local/bin/yoink";
  version = "0.0.1";

  src = ./.;

  dontBuild = true;

  buildInputs = [
    local_bin_win32yank
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./yoink $out/bin/

    runHook postInstall
  '';
}
