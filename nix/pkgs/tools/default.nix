{ fzf, git, pandoc, pkgs, python3, stdenv, vim, ... }:

stdenv.mkDerivation {
  pname = "tools";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "cparadis6191";
    repo = "tools";
    rev = "ba17f2e7555c44a0d04496bc102cba059c5d3fe5";
    hash = "sha256-tb/33aN0PtIHTyO7ocyh+hNwBJu+xYAmV0F7i/N/7qs=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install -D ./bits/bits.py              $out/bin/
    install -D ./colore/colore             $out/bin/
    install -D ./fzyedit/fzyedit           $out/bin/
    install -D ./fzyoink/fzyoink           $out/bin/
    install -D ./git-fzfixup/git-fzfixup   $out/bin/
    install -D ./git-quickfix/git-quickfix $out/bin/
    install -D ./git-rmhooks/git-rmhooks   $out/bin/
    install -D ./mkjournals/mkjournals     $out/bin/
    install -D ./mkmd/mkmd                 $out/bin/
    install -D ./panhandle/panhandle       $out/bin/
    install -D ./panpype/panpype           $out/bin/
    install -D ./qfvim/qfvim               $out/bin/
    install -D ./vicmd/vicmd               $out/bin/
    install -D ./vipe/vipe                 $out/bin/
    install -D ./yeet/yeet                 $out/bin/

    runHook postInstall
  '';

  outputs = [ "out" ];
}
