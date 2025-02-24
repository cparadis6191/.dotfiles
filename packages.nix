{ pkgs, ... }:

let
  local_bin_win32yank = pkgs.callPackage ./local/.local/bin/win32yank/default.nix { };
in
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (pkgs.callPackage ./local/.local/bin/default.nix { })

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
    pkgs.lsof
    pkgs.moreutils
    pkgs.neovim
    pkgs.nixpkgs-fmt
    pkgs.python3
    pkgs.renameutils
    pkgs.ripgrep
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
