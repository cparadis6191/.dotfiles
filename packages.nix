{ pkgs, ... }:

let
  github_fzf_git_sh = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "fzf-git.sh";
      rev = "faecaec7ac599ceccf0a03f6d01e1ffab23a7fba";
      hash = "sha256-owuw1O/LjnNzIzaUogXcDVogOYdZzBkr0Nq9fLs3xc8=";
    })
    { };

  github_fzf_tmux = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "fzf-tmux";
      rev = "455d79e11c09437771f5176bb6c01703e8d14658";
      hash = "sha256-++iM6jOdq/5a49jmFyMKv8A4MHxEFLwqaihrh3F7+Qg=";
    })
    { };

  local_bin_win32yank = pkgs.callPackage ./local/.local/bin/win32yank/default.nix { };
in
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    github_fzf_git_sh
    github_fzf_tmux

    (pkgs.callPackage ./local/.local/bin/default.nix { })
    (pkgs.callPackage ./local/.local/bin/fdfind/default.nix { })
    (pkgs.callPackage ./local/.local/bin/ls/default.nix { })

    local_bin_win32yank
    (pkgs.callPackage ./local/.local/bin/win32yank/yeet-impl/default.nix { inherit local_bin_win32yank; })
    (pkgs.callPackage ./local/.local/bin/win32yank/yoink/default.nix { inherit local_bin_win32yank; })

    (pkgs.callPackage ./local/.local/bin/xxd/default.nix { })

    pkgs.alacritty-theme
    pkgs.bat
    pkgs.ctags
    pkgs.curl
    pkgs.diff-so-fancy
    pkgs.eza
    pkgs.fd
    pkgs.fish
    pkgs.fzf
    pkgs.git
    pkgs.hyperfine
    pkgs.lsof
    pkgs.moreutils
    pkgs.neovim
    pkgs.nixpkgs-fmt
    pkgs.python3
    pkgs.renameutils
    pkgs.ripgrep
    pkgs.ruff
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.stow
    pkgs.tmux
    pkgs.unzip
    pkgs.virtualenv
    pkgs.xclip
    pkgs.xxd

    pkgs.charasay
    pkgs.cowsay
    pkgs.dotacat
    pkgs.figlet
    pkgs.fortune
    pkgs.toilet

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
