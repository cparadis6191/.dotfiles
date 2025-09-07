{ fzf, pkgs, stdenv, tmux, ... }:

stdenv.mkDerivation {
  pname = "fzf-tmux-sh";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "cparadis6191";
    repo = "fzf-tmux.sh";
    rev = "4290be539d8afa24c66354fe07d475ea05196ec4";
    hash = "sha256-8wnho3ZKg67ysi9kC+SeHR6D0F/oiw6Sn09ZkuFm30w=";
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

