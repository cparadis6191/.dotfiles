{ pkgs, ... }:

let
  local_bin_win32yank = pkgs.callPackage ./local/.local/bin/win32yank/default.nix { };

  nb = pkgs.nb.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "cparadis6191";
      repo = "nb";
      rev = "0f5a70fc559225640e524cc74b10f7a4387ee989";
      hash = "sha256-HC4Yo7lmSa42ASkxNLkxidABQMCAoJuQb+g5ZbqBjfg=";
    };
  };
in
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (pkgs.callPackage ./local/.local/bin/bookmark/default.nix { })
    (pkgs.callPackage ./local/.local/bin/default.nix { })
    (pkgs.callPackage ./local/.local/bin/fdfind/default.nix { })
    (pkgs.callPackage ./local/.local/bin/journal/default.nix { })
    (pkgs.callPackage ./local/.local/bin/ls/default.nix { })
    (pkgs.callPackage ./local/.local/bin/note/default.nix { })
    (pkgs.callPackage ./local/.local/bin/text_proc/default.nix { })
    (pkgs.callPackage ./local/.local/bin/time/default.nix { })

    local_bin_win32yank
    (pkgs.callPackage ./local/.local/bin/win32yank/yeet-impl/default.nix { inherit local_bin_win32yank; })
    (pkgs.callPackage ./local/.local/bin/win32yank/yoink/default.nix { inherit local_bin_win32yank; })

    (pkgs.callPackage ./local/.local/bin/xxd/default.nix { })

    (pkgs.callPackage ./nix/pkgs/fzf-git.sh/default.nix { })
    (pkgs.callPackage ./nix/pkgs/fzf-tmux.sh/default.nix { })
    (pkgs.callPackage ./nix/pkgs/tools/default.nix { })

    nb

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
    pkgs.uv
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
