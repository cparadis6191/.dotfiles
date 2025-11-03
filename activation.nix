{ lib, pkgs, ... }:

let
  alacritty_terminfo = (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/alacritty/alacritty/a2334ff494a26a38f66685d0f950a9b589ac84a9/extra/alacritty.info";
    hash = "sha256-j9PDn6Yn0/YxK/dxDzADDOItUVjkDfwq6JOLXpH/vjQ=";
  });

  tinted_shell = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-shell";
    rev = "1099c2e60b2240f843d1b7ee3aef55617472c99c";
    hash = "sha256-WQ8jPUZzTWY5ITO8WRQ0kOZv1hq1XSujaG4Bl5bvwDU=";
  };
in
{
  home.activation = {
    compileAlacrittyTerminfo = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      tic -e alacritty,alacritty-direct -o "$HOME/.terminfo" -x "${alacritty_terminfo}"
    '';

    makeLocalBin = lib.hm.dag.entryAfter [ "makeLocalBashStartupFiles" "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/bin" ]; then
      	run mkdir --parents "$HOME/.local/bin"
      fi

      if [ "$(grep --count 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';

    makeLocalEtc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/etc" ]; then
      	run mkdir --parents "$HOME/.local/etc"
      fi
    '';

    makeLocalAlacrittyConfigurationFile = lib.hm.dag.entryAfter [ "makeLocalEtc" "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/etc/.config/alacritty" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/alacritty"
      fi

      if [ ! -f "$HOME/.local/etc/.config/alacritty/alacritty.toml" ]; then
      	run touch "$HOME/.local/etc/.config/alacritty/alacritty.toml"
      fi
    '';

    makeLocalBashStartupFiles = lib.hm.dag.entryAfter [ "makeLocalEtc" "writeBoundary" ] ''
      if [ ! -f "$HOME/.local/etc/.bash_profile" ]; then
      	run touch "$HOME/.local/etc/.bash_profile"
      fi

      if [ ! -f "$HOME/.local/etc/.bashrc" ]; then
      	run touch "$HOME/.local/etc/.bashrc"
      fi

      if [ "$(grep --count 'eval "$("$HOME/.nix-profile/bin/fzf" --bash)"' "$HOME/.local/etc/.bashrc")" -eq 0 ]; then
      	run echo 'eval "$("$HOME/.nix-profile/bin/fzf" --bash)"' >> "$HOME/.local/etc/.bashrc"
      fi

      if [ "$(grep --count 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.sh"' "$HOME/.local/etc/.bashrc")" -eq 0 ]; then
      	run echo 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.sh"' >> "$HOME/.local/etc/.bashrc"
      fi

      if [ "$(grep --count 'source "$HOME/.nix-profile/share/fzf-tmux.sh/fzf-tmux.sh"' "$HOME/.local/etc/.bashrc")" -eq 0 ]; then
      	run echo 'source "$HOME/.nix-profile/share/fzf-tmux.sh/fzf-tmux.sh"' >> "$HOME/.local/etc/.bashrc"
      fi
    '';

    makeFishInitializationFile = lib.hm.dag.entryAfter [ "makeLocalEtc" "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/etc/.config/fish" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/fish"
      fi

      if [ ! -f "$HOME/.local/etc/.config/fish/config.fish" ]; then
      	run touch "$HOME/.local/etc/.config/fish/config.fish"
      fi

      if [ "$(grep --count '"$HOME/.nix-profile/bin/direnv" hook fish | source' "$HOME/.local/etc/.config/fish/config.fish")" -eq 0 ]; then
      	run echo '"$HOME/.nix-profile/bin/direnv" hook fish | source' >> "$HOME/.local/etc/.config/fish/config.fish"
      fi

      if [ "$(grep --count '"$HOME/.nix-profile/bin/fzf" --fish | source' "$HOME/.local/etc/.config/fish/config.fish")" -eq 0 ]; then
      	run echo '"$HOME/.nix-profile/bin/fzf" --fish | source' >> "$HOME/.local/etc/.config/fish/config.fish"
      fi

      if [ "$(grep --count 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.fish"' "$HOME/.local/etc/.config/fish/config.fish")" -eq 0 ]; then
      	run echo 'source "$HOME/.nix-profile/share/fzf-git.sh/fzf-git.fish"' >> "$HOME/.local/etc/.config/fish/config.fish"
      fi

      if [ "$(grep --count 'source "$HOME/.nix-profile/share/fzf-tmux.sh/fzf-tmux.fish"' "$HOME/.local/etc/.config/fish/config.fish")" -eq 0 ]; then
      	run echo 'source "$HOME/.nix-profile/share/fzf-tmux.sh/fzf-tmux.fish"' >> "$HOME/.local/etc/.config/fish/config.fish"
      fi
    '';

    makeLocalGitconfig = lib.hm.dag.entryAfter [ "makeLocalEtc" "writeBoundary" ] ''
      if [ ! -f "$HOME/.local/etc/.gitconfig" ]; then
      	run touch "$HOME/.local/etc/.gitconfig"
      fi
    '';

    makeLocalInputrc = lib.hm.dag.entryAfter [ "makeLocalEtc" "writeBoundary" ] ''
      if [ ! -f "$HOME/.local/etc/.inputrc" ]; then
      	run touch "$HOME/.local/etc/.inputrc"
      fi
    '';

    makeLocalNeovimInitializationFiles = lib.hm.dag.entryAfter [ "makeLocalEtc" "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/etc/.config/nvim" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/nvim"
      fi

      if [ ! -f "$HOME/.local/etc/.config/nvim/init.vim" ]; then
      	run touch "$HOME/.local/etc/.config/nvim/init.vim"
      fi
    '';

    makeLocalVimInitializationFiles = lib.hm.dag.entryAfter [ "makeLocalEtc" "writeBoundary" ] ''
      if [ ! -d "$HOME/.local/etc/.config/nvim" ]; then
      	run mkdir --parents "$HOME/.local/etc/.config/nvim"
      fi

      if [ ! -f "$HOME/.local/etc/.vimrc" ]; then
      	run touch "$HOME/.local/etc/.vimrc"
      fi
    '';

    setTintedShellThemeDuringBashLogin = lib.hm.dag.entryAfter [ "makeLocalBashStartupFiles" "writeBoundary" ] ''
      # Quoting or escaping the "limit string" at the head of a here document
      # disables parameter substitution within its body.
      run cat << 'HEREDOC' > "$HOME/.local/etc/.tinted_shell_during_bash_login"
      # Tinted Shell
      BASE16_SHELL_PATH="${tinted_shell}"
      [ -n "$PS1" ] && \
      	[ -s "$BASE16_SHELL_PATH/profile_helper.sh" ] && \
      		source "$BASE16_SHELL_PATH/profile_helper.sh"

      base16_ayu-light
      HEREDOC

      if [ "$(grep --count 'source "$HOME/.local/etc/.tinted_shell_during_bash_login"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'source "$HOME/.local/etc/.tinted_shell_during_bash_login"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';

    loadTintedVimColorschemeInLocalVimrc = lib.hm.dag.entryAfter [ "makeLocalVimInitializationFiles" "writeBoundary" ] ''
      # Quoting or escaping the "limit string" at the head of a here document
      # disables parameter substitution within its body.
      run cat << 'HEREDOC' > "$HOME/.local/etc/.tinted.vim"
      if exists('$BASE16_THEME') &&
      			\ (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
      	colorscheme base16-$BASE16_THEME
      endif
      HEREDOC

      if [ "$(grep --count 'source $HOME/.local/etc/.tinted.vim' "$HOME/.local/etc/.vimrc")" -eq 0 ]; then
      	run echo 'source $HOME/.local/etc/.tinted.vim' >> "$HOME/.local/etc/.vimrc"
      fi
    '';

    tmuxAttachDuringBashLogin = lib.hm.dag.entryAfter [ "makeLocalBashStartupFiles" "writeBoundary" ] ''
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

      if [ "$(grep --count 'source "$HOME/.local/etc/.tmux_attach_during_bash_login"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'source "$HOME/.local/etc/.tmux_attach_during_bash_login"' >> "$HOME/.local/etc/.bash_profile"
      fi
    '';

    createAndActivateVirtualenv = lib.hm.dag.entryAfter [ "installPackages" "makeLocalBashStartupFiles" "writeBoundary" ] ''
      if [ ! -d "$HOME/.virtualenv" ]; then
      	run "$HOME/.nix-profile/bin/uv" venv --no-project --python "$HOME/.nix-profile/bin/python3" --seed --system-site-packages "$HOME/.virtualenv"
      fi

      if [ "$(grep --count 'export VIRTUAL_ENV_DISABLE_PROMPT=1' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'export VIRTUAL_ENV_DISABLE_PROMPT=1' >> "$HOME/.local/etc/.bash_profile"
      fi

      if [ "$(grep --count 'source "$HOME/.virtualenv/bin/activate"' "$HOME/.local/etc/.bash_profile")" -eq 0 ]; then
      	run echo 'source "$HOME/.virtualenv/bin/activate"' >> "$HOME/.local/etc/.bash_profile"
      fi

      run cat << 'HEREDOC' > "$HOME/.virtualenv/lib/python3.13/site-packages/usercustomize.py"
      #!/usr/bin/env python3


      import os
      import pathlib
      import sys


      nix_profiles = map(pathlib.Path, os.environ.get("NIX_PROFILES", "").split(" "))
      nix_profiles_site_packages = filter(
          pathlib.Path.exists,
          map(
              lambda nix_profile: nix_profile
              / "lib"
              / f"python{sys.version_info.major}.{sys.version_info.minor}"
              / "site-packages",
              nix_profiles,
          ),
      )

      sys.path = list(map(str, nix_profiles_site_packages)) + sys.path
      HEREDOC

      source "$HOME/.virtualenv/bin/activate"
    '';
  };
}
