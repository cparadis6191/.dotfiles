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

  imports = [
    ./file.nix
    ./packages.nix
  ];

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
