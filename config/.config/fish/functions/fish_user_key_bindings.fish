function fish_use_exit_to_leave_the_shell
    if test -z (commandline --current-buffer)
        echo '
Use "exit" to leave the shell.'

        commandline --function repaint
    end
end

function fish_tab_complete_more_like_bash
    if not commandline --paging-mode
        commandline --function complete
    end
end

function fish_user_key_bindings
    # Approximate bash `set -o ignoreeof`.
    bind \cd fish_use_exit_to_leave_the_shell

    # Make tab complete more like bash.
    bind \t fish_tab_complete_more_like_bash
end
