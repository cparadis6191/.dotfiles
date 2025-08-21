{ lib, pkgs, ... }:

{
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
      	tmux_detached_session="$(tmux list-sessions -F "#{session_id}$delim#{session_name}$delim#{session_attached}" 2> /dev/null |
      		sed --expression="/''\${delim}git fugit''\${delim}/d" \
      			--expression="/''\${delim}python''\${delim}/d" \
      			--expression="/''\${delim}yedit''\${delim}/d" |
      		grep --basic-regexp --regexp="''\${delim}0$" |
      		head --lines=1 |
      		cut --fields=1)"
      	if [[ $tmux_detached_session != ''' ]]; then
      		exec tmux attach-session -t "$tmux_detached_session" \; unbind-key d
      	else
      		exec tmux new-session \; unbind-key d
      	fi
      fi
      HEREDOC

      	run touch "$HOME/.local/etc/.tmux_attach_during_bash_login"
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
