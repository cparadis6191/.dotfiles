{ pkgs, ... }:

{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".bash_profile".source = ./bash/.bash_profile;
    ".bashrc".source = ./bash/.bashrc;

    ".config/alacritty/alacritty.toml".source = ./config/.config/alacritty/alacritty.toml;

    ".config/bat/config".source = ./config/.config/bat/config;

    ".config/fish/config.fish".source = ./config/.config/fish/config.fish;
    ".config/fish/functions/fish_greeting.fish".source = ./config/.config/fish/functions/fish_greeting.fish;
    ".config/fish/functions/fish_prompt.fish".source = ./config/.config/fish/functions/fish_prompt.fish;
    ".config/fish/functions/fish_title.fish".source = ./config/.config/fish/functions/fish_title.fish;
    ".config/fish/functions/fish_user_key_bindings.fish".source = ./config/.config/fish/functions/fish_user_key_bindings.fish;

    ".config/nvim/init.vim".source = ./config/.config/nvim/init.vim;
    ".config/nvim/plugin/treesitter.vim".source = ./config/.config/nvim/plugin/treesitter.vim;

    ".git_template/hooks/post-checkout".source = ./git/.git_template/hooks/post-checkout;
    ".git_template/hooks/post-commit".source = ./git/.git_template/hooks/post-commit;
    ".git_template/hooks/post-merge".source = ./git/.git_template/hooks/post-merge;
    ".git_template/hooks/post-rewrite".source = ./git/.git_template/hooks/post-rewrite;
    ".git_template/hooks/tags".source = ./git/.git_template/hooks/tags;
    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore_global".source = ./git/.gitignore_global;

    ".inputrc".source = ./inputrc/.inputrc;

    ".pandoc/filters/diagram.lua".source = (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cparadis6191/diagram/e2d0fe818152fb024e158313aed0609869d77dfc/_extensions/diagram/diagram.lua";
      hash = "sha256-hWqVf10Yiqrraw8IABEJK4xa2/+wDwICO0benyl0bO8=";
    });

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
