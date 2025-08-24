{ pkgs, ... }:

let
  github_fzf_git_sh = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "fzf-git.sh";
      rev = "32237f1fc8feba2204eb8031b91be810bb67b637";
      hash = "sha256-OnwMV3LVkXEqQNp1puYefFh0nfk3M1LAyWBhpmDC0Yo=";
    })
    { };

  github_fzf_tmux = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "fzf-tmux";
      rev = "b141eae15d467e6916cd558c5ca0606cc1f515d9";
      hash = "sha256-eQXrZvQYoypiFISSY+q1fSli8jzweVRxMgt71VCSXL8=";
    })
    { };

  github_tools = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "tools";
      rev = "0438dd1cef669ce8dbca4947932330a2800e3109";
      hash = "sha256-JuS7WLAffET+o9z7+HHhq4Fi/M95dovvOlinr+5k+q4=";
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
