{ fzf, git, pkgs, stdenv, ... }:

stdenv.mkDerivation {
  pname = "fzf-git-sh";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "cparadis6191";
    repo = "fzf-git.sh";
    rev = "954c8dad83ddabcdf1806bc250b2bccd8efc7f07";
    hash = "sha256-j2chBp9O54gprT0rdALYo+NMDmE13/fydpFsPaKJG+A=";
  };

  buildInputs = [ fzf git ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/share/fzf-git.sh/

    install -D ./fzf-git.fish $out/share/fzf-git.sh/
    install -D ./fzf-git.sh   $out/share/fzf-git.sh/

    runHook postInstall
  '';

  outputs = [ "out" ];
}

