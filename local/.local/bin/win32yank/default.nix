{ fetchzip, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-bin-win32yank";
  version = "0.0.1";

  src = fetchzip {
    url = "https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip";
    sha256 = "4ivE1cYZhYs4ibx5oiYMOhbse9bdOomk7RjgdVl5lD0=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install ./win32yank.exe $out/bin/

    runHook postInstall
  '';
}
