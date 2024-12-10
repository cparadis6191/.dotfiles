function fish_title
    # emacs' "term" is basically the only term that can't handle it.
    if not set -q INSIDE_EMACS; or string match -vq '*,term:*' -- $INSIDE_EMACS
        set -e -l ssh

        if test -n $SSH_CONNECTION
            set ssh "ssh"
        end

        set -l term $TERM

        set -l shell $SHELL

        set -e -l shell_level

        if test $SHLVL -gt 1
            set shell_level [$SHLVL]
        end

        # An override for the current command is passed as the first parameter.
        # This is used by `fg` to show the true process name, among others.
        set -l current_command (set -q argv[1] && echo $argv[1] || status current-command)

        echo -s $ssh " "$term " "$shell " "$shell_level " "$current_command " "(__fish_pwd)
    end
end
