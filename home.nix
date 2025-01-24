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
    (pkgs.callPackage ./local/.local/bin/package.nix { })

    pkgs.ctags
    pkgs.curl
    pkgs.diff-so-fancy
    pkgs.eza
    pkgs.fd
    pkgs.fish
    pkgs.fzf
    pkgs.git
    pkgs.lsof
    pkgs.neovim
    pkgs.nixpkgs-fmt
    pkgs.python3
    pkgs.ripgrep
    pkgs.stow
    pkgs.tmux
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

    tmuxAttachDuringBashLogin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "$HOME/.local/etc/.tmux_attach_during_bash_login" ]; then
      	# Quoting or escaping the "limit string" at the head of a here document
      	# disables parameter substitution within its body.
      	run cat << 'HEREDOC' >> "$HOME/.local/etc/.bash_profile"
# Attach to an existing tmux session if no client is attached, otherwise start
# a new session.
if [[ $TMUX == ''' && $(command -v 'tmux') != ''' ]]; then
	delim=$'\t'
	tmux_detached_session="$(tmux list-sessions -F "#{session_id}$delim#{session_attached}" 2> /dev/null |
		grep --basic-regexp --regexp='0$' |
		head --lines=1 |
		cut --fields=1)"
	if [[ $tmux_detached_session != ''' ]]; then
		exec tmux attach-session -t "$tmux_detached_session" \; unbind-key d
	else
		exec tmux new-session \; unbind-key d
	fi
fi
HEREDOC

      	touch "$HOME/.local/etc/.tmux_attach_during_bash_login"
      fi
    '';

    createAndActivateVirtualenv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.virtualenv" ]; then
        run ${pkgs.virtualenv}/bin/virtualenv --download "$HOME/.virtualenv"
        run echo 'VIRTUAL_ENV_DISABLE_PROMPT=1' >> "$HOME/.local/etc/.bash_profile"
        run echo 'source "$HOME/.virtualenv/bin/activate"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';
  };
}
