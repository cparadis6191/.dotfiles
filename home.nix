{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "chad";
  home.homeDirectory = "/home/chad";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ctags
    pkgs.curl
    pkgs.fd
    pkgs.fish
    pkgs.fzf
    pkgs.git
    pkgs.lsof
    pkgs.neovim
    pkgs.ripgrep
    pkgs.stow
    pkgs.unzip
    pkgs.virtualenv

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".alacritty.toml".source = ./alacritty/.alacritty.toml;
    ".alacritty.yml".source = ./alacritty/.alacritty.yml;

    ".bash_profile".source = ./bash/.bash_profile;
    ".bashrc".source = ./bash/.bashrc;

    ".config/bat/config".source = ./config/.config/bat/config;

    ".config/fish/.gitignore".source = ./config/.config/fish/.gitignore;
    ".config/fish/config.fish".source = ./config/.config/fish/config.fish;
    ".config/fish/functions/fish_prompt.fish".source = ./config/.config/fish/functions/fish_prompt.fish;
    ".config/fish/functions/fish_title.fish".source = ./config/.config/fish/functions/fish_title.fish;
    ".config/fish/functions/fish_user_key_bindings.fish".source = ./config/.config/fish/functions/fish_user_key_bindings.fish;

    ".git_template/hooks/post-checkout".source = ./git/.git_template/hooks/post-checkout;
    ".git_template/hooks/post-commit".source = ./git/.git_template/hooks/post-commit;
    ".git_template/hooks/post-merge".source = ./git/.git_template/hooks/post-merge;
    ".git_template/hooks/post-rewrite".source = ./git/.git_template/hooks/post-rewrite;
    ".git_template/hooks/tags".source = ./git/.git_template/hooks/tags;
    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore_global".source = ./git/.gitignore_global;

    ".inputrc".source = ./inputrc/.inputrc;

    ".tmux.conf".source = ./tmux/.tmux.conf;

    ".vim/plugin/fzf_neosnippets/plugin/fzf_neosnippets.vim".source = ./vim/.vim/plugin/fzf_neosnippets/plugin/fzf_neosnippets.vim;
    ".vim/plugin/fzf_quickfix/plugin/fzf_quickfix.vim".source = ./vim/.vim/plugin/fzf_quickfix/plugin/fzf_quickfix.vim;
    ".vim/plugin/journal/ftdetect/journal.vim".source = ./vim/.vim/plugin/journal/ftdetect/journal.vim;
    ".vim/plugin/journal/neosnippets/journal.snip".source = ./vim/.vim/plugin/journal/neosnippets/journal.snip;
    ".vim/plugin/journal/syntax/journal.vim".source = ./vim/.vim/plugin/journal/syntax/journal.vim;
    ".vim/plugin/normal_expr/plugin/normal_expr.vim".source = ./vim/.vim/plugin/normal_expr/plugin/normal_expr.vim;
    ".vim/plugin/note/autoload/note.vim".source = ./vim/.vim/plugin/note/autoload/note.vim;
    ".vim/plugin/note/plugin/note.vim".source = ./vim/.vim/plugin/note/plugin/note.vim;
    ".vim/plugin/search/plugin/search.vim".source = ./vim/.vim/plugin/search/plugin/search.vim;
    ".vim/plugin/visual_selection/autoload/visual_selection.vim".source = ./vim/.vim/plugin/visual_selection/autoload/visual_selection.vim;
    ".vimrc".source = ./vim/.vimrc;

    ".local/bin/binxxd".source = ./local/.local/bin/binxxd;
    ".local/bin/calc".source = ./local/.local/bin/calc;
    ".local/bin/cdb".source = ./local/.local/bin/cdb-impl;
    ".local/bin/cxxd".source = ./local/.local/bin/cxxd;
    ".local/bin/hexxd".source = ./local/.local/bin/hexxd;
    ".local/bin/isotounix".source = ./local/.local/bin/isotounix;
    ".local/bin/journal".source = ./local/.local/bin/journal;
    ".local/bin/journals".source = ./local/.local/bin/journals;
    ".local/bin/la".source = ./local/.local/bin/la;
    ".local/bin/ll".source = ./local/.local/bin/ll;
    ".local/bin/mkb".source = ./local/.local/bin/mkb;
    ".local/bin/post".source = ./local/.local/bin/post;
    ".local/bin/pre".source = ./local/.local/bin/pre;
    ".local/bin/repeat".source = ./local/.local/bin/repeat;
    ".local/bin/stopwatch".source = ./local/.local/bin/stopwatch;
    ".local/bin/texxd".source = ./local/.local/bin/texxd;
    ".local/bin/unixtoiso".source = ./local/.local/bin/unixtoiso;
    ".local/bin/unixtolocaliso".source = ./local/.local/bin/unixtolocaliso;
    ".local/bin/vim".source = ./local/.local/bin/vim;
    ".local/bin/vrep".source = ./local/.local/bin/vrep;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/chad/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.activation = {
    makeLocalEtc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/etc" ]; then
        run mkdir --parents "$HOME/.local/etc"
      fi
    '';

    makeLocalBin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/bin" ]; then
        run mkdir --parents "$HOME/.local/bin"
        run echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';
  };
}
