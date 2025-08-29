{ lib, pkgs, ... }:

{
  home.activation = {
    makeLocalBin = lib.hm.dag.entryAfter [ "makeLocalBashStartupFiles" ] ''
      if [ ! -d "$HOME/.local/bin" ]; then
      	run mkdir --parents "$HOME/.local/bin"
      fi

      if [ "$(grep -c 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';

    makeLocalEtc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/etc" ]; then
      	run mkdir --parents "$HOME/.local/etc"
      fi
    '';

    makeLocalAlacrittyConfigurationFile = lib.hm.dag.entryAfter [ "makeLocalEtc" ] ''
      if [ ! -d "$HOME/.local/etc/.config/alacritty" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/alacritty"
      fi

      if [ ! -f "$HOME/.local/etc/.config/alacritty/alacritty.toml" ]; then
      	run touch "$HOME/.local/etc/.config/alacritty/alacritty.toml"
      fi
    '';

    makeLocalBashStartupFiles = lib.hm.dag.entryAfter [ "makeLocalEtc" ] ''
      if [ ! -f "$HOME/.local/etc/.bash_profile" ]; then
      	run touch "$HOME/.local/etc/.bash_profile"
      fi

      if [ "$(grep -c 'eval "$("$HOME/.nix-profile/bin/fzf" --bash)"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'eval "$("$HOME/.nix-profile/bin/fzf" --bash)"' >> "$HOME/.local/etc/.bash_profile"
      fi

      if [ "$(grep -c 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.sh"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.sh"' >> "$HOME/.local/etc/.bash_profile"
      fi

      if [ ! -f "$HOME/.local/etc/.bashrc" ]; then
      	run touch "$HOME/.local/etc/.bashrc"
      fi
    '';

    makeFishInitializationFile = lib.hm.dag.entryAfter [ "makeLocalEtc" ] ''
      if [ ! -d "$HOME/.local/etc/.config/fish" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/fish"
      fi

      if [ ! -f "$HOME/.local/etc/.config/fish/config.fish" ]; then
      	run touch "$HOME/.local/etc/.config/fish/config.fish"
      fi

      if [ "$(grep -c '"$HOME/.nix-profile/bin/fzf" --fish | source' "$HOME/.local/etc/.config/fish/config.fish")" -eq 0 ]; then
      	run echo '"$HOME/.nix-profile/bin/fzf" --fish | source' >> "$HOME/.local/etc/.config/fish/config.fish"
      fi

      if [ "$(grep -c 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.fish"' "$HOME/.local/etc/.config/fish/config.fish")" -eq 0 ]; then
      	run echo 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.fish"' >> "$HOME/.local/etc/.config/fish/config.fish"
      fi

      if [ "$(grep -c 'source "$HOME/.nix-profile/share/fzf-tmux/fzf-tmux.fish"' "$HOME/.local/etc/.config/fish/config.fish")" -eq 0 ]; then
      	run echo 'source "$HOME/.nix-profile/share/fzf-tmux/fzf-tmux.fish"' >> "$HOME/.local/etc/.config/fish/config.fish"
      fi
    '';

    makeLocalGitconfig = lib.hm.dag.entryAfter [ "makeLocalEtc" ] ''
      if [ ! -f "$HOME/.local/etc/.gitconfig" ]; then
      	run touch "$HOME/.local/etc/.gitconfig"
      fi
    '';

    makeLocalInputrc = lib.hm.dag.entryAfter [ "makeLocalEtc" ] ''
      if [ ! -f "$HOME/.local/etc/.inputrc" ]; then
      	run touch "$HOME/.local/etc/.inputrc"
      fi

      if [ "$(grep -c '$include ~/.nix-profile/share/fzf-tmux/fzf-tmux.inputrc' "$HOME/.local/etc/.inputrc")" -eq 0 ]; then
      	run echo '$include ~/.nix-profile/share/fzf-tmux/fzf-tmux.inputrc' >> "$HOME/.local/etc/.inputrc"
      fi
    '';

    makeLocalNeovimInitializationFiles = lib.hm.dag.entryAfter [ "makeLocalEtc" ] ''
      if [ ! -d "$HOME/.local/etc/.config/nvim" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/nvim"
      fi

      if [ ! -f "$HOME/.local/etc/.config/nvim/init.vim" ]; then
      	run touch "$HOME/.local/etc/.config/nvim/init.vim"
      fi
    '';

    makeLocalVimInitializationFiles = lib.hm.dag.entryAfter [ "makeLocalEtc" ] ''
      if [ ! -d "$HOME/.local/etc/.config/nvim" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/nvim"
      fi

      if [ ! -f "$HOME/.local/etc/.vimrc" ]; then
      	run touch "$HOME/.local/etc/.vimrc"
      fi
    '';

    tmuxAttachDuringBashLogin = lib.hm.dag.entryAfter [ "makeLocalBashStartupFiles" ] ''
      # Quoting or escaping the "limit string" at the head of a here document
      # disables parameter substitution within its body.
      run cat << 'HEREDOC' > "$HOME/.local/etc/.tmux_attach_during_bash_login"
      # Attach to an existing tmux session if no client is attached, otherwise start
      # a new session.
      if [[ $TMUX == ''' && $(command -v "$HOME/.nix-profile/bin/tmux") != ''' ]]; then
      	delim=$'\t'
      	tmux_detached_session="$("$HOME/.nix-profile/bin/tmux" list-sessions -F "#{session_id}$delim#{session_name}$delim#{session_attached}" 2> /dev/null |
      		sed --expression="/''\${delim}git fugit''\${delim}/d" \
      			--expression="/''\${delim}python''\${delim}/d" \
      			--expression="/''\${delim}yedit''\${delim}/d" |
      		grep --basic-regexp --regexp="''\${delim}0$" |
      		head --lines=1 |
      		cut --fields=1)"
      	if [[ $tmux_detached_session != ''' ]]; then
      		exec "$HOME/.nix-profile/bin/tmux" attach-session -t "$tmux_detached_session" \; unbind-key d
      	else
      		exec "$HOME/.nix-profile/bin/tmux" new-session \; unbind-key d
      	fi
      fi
      HEREDOC

      if [ "$(grep -c 'source "$HOME/.local/etc/.tmux_attach_during_bash_login"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'source "$HOME/.local/etc/.tmux_attach_during_bash_login"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';

    createAndActivateVirtualenv = lib.hm.dag.entryAfter [ "makeLocalBashStartupFiles" ] ''
      if [ ! -d "$HOME/.virtualenv" ]; then
      	run $HOME/.nix-profile/bin/virtualenv --download "$HOME/.virtualenv"
      fi

      if [ "$(grep -c 'export VIRTUAL_ENV_DISABLE_PROMPT=1' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'export VIRTUAL_ENV_DISABLE_PROMPT=1' >> "$HOME/.local/etc/.bash_profile"
      fi

      if [ "$(grep -c 'source "$HOME/.virtualenv/bin/activate"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'source "$HOME/.virtualenv/bin/activate"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';
  };
}
