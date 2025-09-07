{ fzf, pkgs, stdenv, tmux, ... }:

stdenv.mkDerivation {
  pname = "fzf-tmux-sh";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "cparadis6191";
    repo = "fzf-tmux.sh";
    rev = "9f830f6e5af7532dc85bcd3fdce132cfcdcf1642";
    hash = "sha256-uNz0wboq3XmnmtgF9MXenbLnDYNHupon3iwzFDXjZ40=";
  };

  buildInputs = [ fzf tmux ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/share/fzf-tmux.sh/

    install -D ./fzf-tmux.fish $out/share/fzf-tmux.sh/
    install -D ./fzf-tmux.sh   $out/share/fzf-tmux.sh/

    runHook postInstall
  '';

  outputs = [ "out" ];
}

