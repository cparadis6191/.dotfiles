function fish_tab_complete_more_like_bash
    if not commandline --paging-mode
        commandline --function complete
    end
end

function fish_user_key_bindings
    bind --erase --preset \cd

    # Make tab complete more like bash.
    bind \t fish_tab_complete_more_like_bash
end
