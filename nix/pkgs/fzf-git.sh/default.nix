{ fzf, git, pkgs, stdenv, ... }:

stdenv.mkDerivation {
  pname = "fzf-git-sh";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "cparadis6191";
    repo = "fzf-git.sh";
    rev = "a6426e615fb9966b99999ae0668847c36e8f53c2";
    hash = "sha256-oMtOCdexNh37Y9kvxzKsjuKM+Dw3r7zbNm9U8O9gpxg=";
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

