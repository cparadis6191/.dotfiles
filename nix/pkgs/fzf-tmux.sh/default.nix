{ fzf, pkgs, stdenv, tmux, ... }:

stdenv.mkDerivation {
  pname = "fzf-tmux-sh";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "cparadis6191";
    repo = "fzf-tmux.sh";
    rev = "43754b52dcf3e76eca073339a84bd4b413d41f05";
    hash = "sha256-ARl7xJKmtxH16DjRJ0S2h0x2y5GaO0t1+MmCONmR2IM=";
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

