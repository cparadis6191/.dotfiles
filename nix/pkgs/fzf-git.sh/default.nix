{ fzf, git, pkgs, stdenv, ... }:

stdenv.mkDerivation {
  pname = "fzf-git-sh";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "cparadis6191";
    repo = "fzf-git.sh";
    rev = "5dc6d7af4b424ceaaf56bdfff43b35f2e8a6d070";
    hash = "sha256-UGXqTlhg04xtOc0jjwqjWop+awF0U6/f6rJQnukkD90=";
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

