{ pkgs, ... }:

let
  github_fzf_git_sh = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "fzf-git.sh";
      rev = "5dc6d7af4b424ceaaf56bdfff43b35f2e8a6d070";
      hash = "sha256-UGXqTlhg04xtOc0jjwqjWop+awF0U6/f6rJQnukkD90=";
    })
    { };

  github_fzf_tmux = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "fzf-tmux";
      rev = "d99305a6c197e4f626a94336ee3b4f39bd872d40";
      hash = "sha256-9QSAPEEKCBEjmdFr2mMfnRn2taqjJdWnaMqr/InjrXk=";
    })
    { };

  github_tools = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "tools";
      rev = "3719d963bead63d035e9f89cd2370cb201105936";
      hash = "sha256-fOwDKTec/9rof7MMIiW1E3ZD02XxThw2kzXCry00Te4=";
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
    github_tools

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
