{ ... }:

{
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
}
